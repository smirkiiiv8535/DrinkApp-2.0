//
//  OrderTable.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/16.
//

import UIKit

class OrderTable: UITableViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var sugarDecision: UISegmentedControl!
    @IBOutlet weak var iceDecision: UISegmentedControl!
    @IBOutlet weak var cupDecision: UISegmentedControl!
    @IBOutlet weak var bubbleDecision: UISwitch!
    @IBOutlet weak var priceText: UILabel!
    
    var getOrders = [initOrder]()
    var pickedDrink:initOrder!

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadMenu()
    }
    
    func downloadMenu(){
        let urlLink = URL(string: UrlRequestTask.shared.menuLink)
        var requestMenu = URLRequest(url: urlLink!)
        requestMenu.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestMenu) { (data, response, error) in
            if let data = data , let menuData = try? JSONDecoder().decode(GoogleSheetJSON.self, from: data){
                
                let menuList = menuData.feed.entry
                
                for i in 0...menuList.count - 1 {
                    let drink = menuList[i].drinkName.text
                    let price = menuList[i].mediumPrice.text
                    let picture = menuList[i].drinkPicture.text
                    let order = initOrder(drinkName: drink, price: Int(price)!, drinkImageLink: picture)
                    self.getOrders.append(order)
                }
                //預設取得飲料名稱跟價格為第一個飲料
                self.pickedDrink = self.getOrders[0]
              }
        }.resume()
    }
    
    func updateSize(){
        cupDecision.selectedSegmentIndex = 0
    }
    
    var getPictureLink:String = ""
    @IBAction func pickDrink(_ sender: UIButton) {
        updateSize()
        let mediumOnly = ["熟成檸果","墨玉歐特"]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for drink in getOrders{
            let alertAction = UIAlertAction(title: drink.drinkName, style: .default) { (_) in
                self.pickedDrink = drink
                sender.setTitle(self.pickedDrink.drinkName, for: .normal)
                self.priceText.text = "$  \(self.pickedDrink.price)"
                self.getPictureLink = drink.drinkImageLink
                if mediumOnly.contains(drink.drinkName){
                    self.cupDecision.setEnabled(false, forSegmentAt: 1)
                }
             }
            alertController.addAction(alertAction)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)

    }
    
    var sugar:Sugar = .noSugar
    @IBAction func confirmSugar(_ sender: Any) {
        switch sugarDecision.selectedSegmentIndex{
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
    @IBAction func confirmIce(_ sender: Any) {
      switch iceDecision.selectedSegmentIndex{
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
    @IBAction func confirmSize(_ sender: Any) {
        
        if cupDecision.selectedSegmentIndex == 1{
            size = .large
            pickedDrink.price += 5
        }else{
            size = .medium
            pickedDrink.price -= 5
        }
            
        DispatchQueue.main.async {
            self.priceText.text = "$  \(self.pickedDrink.price)"
        }
    }
    
    var getBubble:Bubble = .noBubble
    @IBAction func confirmBubble(_ sender: Any) {
                
        if bubbleDecision.isOn{
            pickedDrink.price += 5
            getBubble = .haveBubble
        }else{
            pickedDrink.price -= 5
            getBubble = .noBubble
        }
                
        DispatchQueue.main.async {
            self.priceText.text = "$  \(self.pickedDrink.price)"
        }
        
    }
        
    @IBAction func confirmOrder(_ sender: Any) {
           uploadData()
    }
    
    func uploadData(){
        let name = nameText.text!
        let drink = drinkButton.title(for: .normal) ?? ""
        let sugar = self.sugar.rawValue
        let ice = self.ice.rawValue
        let size = self.size.rawValue
        let bubble = self.getBubble.rawValue
        let price = pickedDrink.price
        let picture = getPictureLink
        
        let newOrder = Order(name :name, drink:drink,chooseSugar: sugar,chooseIce:ice,chooseSize:size,haveBubble:bubble, price :price, pictureLink: picture)
        
        guard nameText.text?.isEmpty==false else {
            let controller = UIAlertController(title: "記得輸入名字喔", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "好喔", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        guard drinkButton.currentTitle?.isEmpty==false else {
            let controller = UIAlertController(title: "請選擇飲料", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "恩恩", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }

          postDrink(newOrder: newOrder)
          let controller = UIAlertController(title: "感恩Peter,讚嘆Peter", message: nil, preferredStyle: .alert)
          controller.addAction(UIAlertAction(title: "訂購完成", style: .default, handler: nil))
          present(controller, animated: true, completion: nil)
      
    }
    
    func postDrink(newOrder:Order){
        let urlLink = URL(string: UrlRequestTask.shared.orderLink)
        var requestToSheetDB = URLRequest(url: urlLink!)
        requestToSheetDB.httpMethod = "POST"
        requestToSheetDB.setValue("application/json", forHTTPHeaderField: "Content-type")
        let orderData = List(data:newOrder)
        if let uploadToDbData = try? JSONEncoder().encode(orderData){
            URLSession.shared.uploadTask(with: requestToSheetDB, from: uploadToDbData){ (data, response, error) in
                if let data = data, let passBackResult = try? JSONDecoder().decode([String:Int].self, from: data), passBackResult["created"] == 1 {
                    print(passBackResult)
                    print("ok")
                }else{
                    print("error")
                }
            }.resume()
        }
    }
}
