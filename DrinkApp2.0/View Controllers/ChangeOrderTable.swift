//
//  ChangeOrderTable.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/18.
//

import UIKit

class ChangeOrderTable: UITableViewController {

    var initPicture:String!
    var editOrder:CanEditData!
    var reEditMenu = [OverWriteOrder]()
    
    @IBOutlet weak var readyFixName: UITextField!
    @IBOutlet weak var readyFixDrink: UIButton!
    @IBOutlet weak var readyFixSugar: UISegmentedControl!
    @IBOutlet weak var readyFixIce: UISegmentedControl!
    @IBOutlet weak var readyFixSize: UISegmentedControl!
    @IBOutlet weak var readyFixBubble: UISwitch!
    @IBOutlet weak var readyFixPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if let editOrder = editOrder {
            readyFixName.text = editOrder.name
            readyFixDrink.setTitle(editOrder.drink, for: .normal)
            readyFixSugar.selectedSegmentIndex = convertIntHelper(drinkString:editOrder.chooseSugar)
            readyFixIce.selectedSegmentIndex = convertIntHelper(drinkString:editOrder.chooseIce)
            readyFixSize.selectedSegmentIndex = convertIntHelper(drinkString:editOrder.chooseSize)
            readyFixBubble.isOn = convertBoolHelper(drinkString:editOrder.haveBubble)
            readyFixPrice.text = "$ \(editOrder.price)"
            initPicture = editOrder.pictureLink
        }
        downloadMenuAgain()
    }
    
    func convertIntHelper(drinkString: String) -> Int {
          switch drinkString {
             case "無糖","去冰","中杯":
               return 0
             case  "微糖","微冰","大杯":
               return 1
             case "半糖", "少冰":
               return 2
             case "少糖","正常" :
               return 3
             case "全糖" :
               return 4
             default:
               return 0
       }
    }
    
    func convertBoolHelper(drinkString: String) -> Bool {
          switch drinkString {
            case "沒珍珠" :
               return false
            case "有珍珠" :
                return true
            default:
                return false
       }
    }
    
    var selectedDrink:OverWriteOrder!
    func downloadMenuAgain(){
        let url = URL(string: UrlRequestTask.shared.spreadSheetMenuLink)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data , let allDrinkData = try? JSONDecoder().decode(GoogleMenuSheetJSON.self, from: data){
                let drinkData = allDrinkData.feed.entry
                
                for i in 0...drinkData.count-1{
                    let drinkName = drinkData[i].drinkName.text
                    let drinkPrice = Int(drinkData[i].mediumPrice.text)!
                    let drinkImage = drinkData[i].drinkPicture.text
                    
                    let drink = OverWriteOrder(drinkName: drinkName, price: drinkPrice, drinkImageLink: drinkImage)
                    self.reEditMenu.append(drink)
                }
                self.selectedDrink = self.reEditMenu[0]
                
            }
        }.resume()
    }
    
     
    
    @IBAction func reWriteDrink(_ sender: UIButton) {
                       
        let mediumOnly = ["熟成檸果","墨玉歐特"]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for drink in reEditMenu{
            let alertAction = UIAlertAction(title: drink.drinkName, style: .default) { (_) in
                self.selectedDrink = drink
                sender.setTitle(drink.drinkName, for: .normal)
                self.readyFixPrice.text = "$  \(self.selectedDrink.price)"
                self.initPicture = drink.drinkImageLink
                if mediumOnly.contains(drink.drinkName){
                    self.readyFixSize.setEnabled(false, forSegmentAt: 1)
                }
            }
            alertController.addAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消修改", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    var sugar:Sugar = .noSugar
    @IBAction func reWriteSugar(_ sender: Any) {
        switch readyFixSugar.selectedSegmentIndex {
        case 0:
            sugar = .noSugar
        case 1:
            sugar = .quarterSugar
        case 2:
            sugar = .halfSugar
        case 3:
            sugar = .threeFourth
        case 4:
            sugar = .regular
        default:
            sugar = .noSugar
        }
    }
    var ice:Ice = .noIce
    @IBAction func reWriteIce(_ sender: Any) {
        switch readyFixIce.selectedSegmentIndex {
        case 0:
            ice = .noIce
        case 1:
            ice = .quarterIce
        case 2:
            ice = .halfIce
        case 3:
            ice = .regular
        default:
            ice = .noIce
        }
    }
    
    var size:Size = .medium
    @IBAction func reWriteSize(_ sender: Any) {
        if readyFixSize.selectedSegmentIndex == 1{
            size = .large
            selectedDrink.price+=5
          }else {
            size = .medium
            selectedDrink.price-=5
        }
        
        
        DispatchQueue.main.async {
            self.readyFixPrice.text = "$  \(self.selectedDrink.price)"
        }
    }
    
    var getBubble:Bubble = .noBubble
    @IBAction func reDecideBubble(_ sender: Any) {
        
        if readyFixBubble.isOn{
            getBubble = .haveBubble
            selectedDrink.price+=5
        }else{
            getBubble = .noBubble
            selectedDrink.price-=5
        }
        DispatchQueue.main.async {
            self.readyFixPrice.text = "$  \(self.selectedDrink.price)"
        }
    }
    
    @IBAction func confirmFixOrder(_ sender: Any) {
        
        update()
         let controller = UIAlertController(title: nil, message: "確定要修改嗎？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
    
    
    func update(){
        
        
        let name = readyFixName.text!
        let drink = readyFixDrink.title(for: .normal) ?? ""
        let sugar = self.sugar.rawValue
        let ice = self.ice.rawValue
        let size = self.size.rawValue
        let bubble = getBubble.rawValue
        let price = String(selectedDrink.price)
        let picture = initPicture
        
        let updatedOrder = CanEditData(name :name, drink:drink,chooseSugar: sugar,chooseIce:ice,chooseSize:size,haveBubble:bubble, price:price, pictureLink: picture!)
        
        guard readyFixName.text?.isEmpty==false else {
            let controller = UIAlertController(title: "記得輸入名字喔", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "好喔", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        guard readyFixDrink.currentTitle?.isEmpty==false else {
            let controller = UIAlertController(title: "請選擇飲料", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "恩恩", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }

        PutSheetDB(order: updatedOrder)
    }
    
    func PutSheetDB(order:CanEditData){
           let url = URL(string: "\(UrlRequestTask.shared.sheetDBOrderLink)/name/\(order.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
           let updateTheOrder = PutDataToSheetDB(data: [order])
        
           if let data = try? JSONEncoder().encode(updateTheOrder){
                 URLSession.shared.uploadTask(with: request, from: data) { (updateData, response, error) in
                 let decoder = JSONDecoder()
                    if let updateData = updateData,let updateDic = try? decoder.decode([String: Int].self, from: updateData), updateDic["updated"] == 1{
                          print("Updated OK")
                        }else{
                          print("updated failed")
                     }
                  }.resume()
          }
            }
    }
 
    


