//
//  OrderList.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/16.
//

import UIKit

class OrderList: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var drinkCount: UILabel!
    @IBOutlet weak var drinkMoney: UILabel!
   var listedDrinks = [CanEditData]()
   var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTable.delegate = self
        orderTable.dataSource = self
        loading()
        fetchDrinks()
    }
       
    override func viewDidAppear(_ animated: Bool) {
       loading()
       fetchDrinks()
       self.orderTable.reloadData()
       stopLoading()
    }
    
    func loading(){
       loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        loadingIndicator.stopAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    func fetchDrinks(){
        let orderUrl = URL(string: UrlRequestTask.shared.spreadSheetOrderLink)
        var request = URLRequest(url: orderUrl!)
        request.httpMethod = "GET"
     
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.listedDrinks.removeAll()
            self.priceBox.removeAll()
          if let data = data, let downloadOrderDrink = try?JSONDecoder().decode(GoogleOrderSheetJSON.self, from: data){
            
            let orderDrinkData = downloadOrderDrink.feed.entry
            
            for i in 0...orderDrinkData.count-1{
                let name = orderDrinkData[i].name.text
                let drink = orderDrinkData[i].drink.text
                let chooseSugar = orderDrinkData[i].chooseSugar.text
                let chooseIce = orderDrinkData[i].chooseIce.text
                let chooseSize = orderDrinkData[i].chooseSize.text
                let haveBubble = orderDrinkData[i].haveBubble.text
                let price = orderDrinkData[i].price.text
                let pictureLink = orderDrinkData[i].pictureLink.text
                let getOneDrink = CanEditData(name: name, drink: drink, chooseSugar: chooseSugar, chooseIce: chooseIce, chooseSize: chooseSize, haveBubble: haveBubble, price: price, pictureLink: pictureLink)
            
                self.listedDrinks.insert(getOneDrink, at: 0)
            }
         }
            DispatchQueue.main.async {
                self.orderTable.reloadData()
                self.updateHaveAddOrder()
                self.stopLoading()
            }
        }.resume()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       listedDrinks.count
    }
    
    var totalPrice = 0
    var priceBox = [Int]()
    func updateHaveAddOrder(){
        drinkCount.text = "\(listedDrinks.count)  杯"
        for i in 0..<listedDrinks.count{
              let sumMoney = Int(listedDrinks[i].price)
            priceBox.append(sumMoney!)
              totalPrice = priceBox.reduce(0, +)
        }
        drinkMoney.text = "$  \(totalPrice)"
    }
    
    func updateHaveMinusOrder(number:Int){
        drinkCount.text = "\(listedDrinks.count)  杯"
        priceBox.remove(at: number)
        totalPrice = priceBox.reduce(0, +)
        drinkMoney.text = "\(totalPrice)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drinkNumber = listedDrinks[indexPath.row]
        let cell = orderTable.dequeueReusableCell(withIdentifier: "DrinkList", for: indexPath) as? DrinkCell
        cell?.drinkimage.image  = UIImage(named: "kebuke")
        cell?.name.text = "\(drinkNumber.name)"
        cell?.drink.text = "\(drinkNumber.drink)"
        cell?.sugar.text = "\(drinkNumber.chooseSugar)"
        cell?.ice.text = "\(drinkNumber.chooseIce)"
        cell?.size.text = "\(drinkNumber.chooseSize)"
        cell?.dollar.text = "\(drinkNumber.price)"
        
        if let drinkImageLink = URL(string: drinkNumber.pictureLink){
            URLSession.shared.dataTask(with: drinkImageLink) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell?.drinkimage.image  = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell!
    }
    
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doDelete = UIContextualAction(style: .destructive, title: "刪除") { (action, view, completion) in
            let orderNumber = indexPath.row
            self.deleteDrinks(name: self.listedDrinks[orderNumber].name){(_) in}
            self.listedDrinks.remove(at: orderNumber)
            self.orderTable.deleteRows(at: [indexPath], with: .fade)
            self.updateHaveMinusOrder(number:orderNumber)
        }
        var swipeAction = UISwipeActionsConfiguration()
        swipeAction = UISwipeActionsConfiguration(actions: [doDelete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }

    func deleteDrinks(name: String,completionHandler: @escaping(String) -> Void) {

        let deleteDrinkUrl = URL(string: "\(UrlRequestTask.shared.sheetDBOrderLink)/name/\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: deleteDrinkUrl!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       URLSession.shared.dataTask(with: request) { (updatedData, response, error) in
           if let updatedData = updatedData, let dictionary = try? JSONDecoder().decode([String: Int].self, from: updatedData), dictionary["deleted"] == 1{
            completionHandler("刪除成功")
                    }else{
            completionHandler("刪除失敗")
                    }
         }.resume()
  }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as?  ChangeOrderTable,let row = orderTable.indexPathForSelectedRow?.row{
            let download = listedDrinks[row]
            controller.editOrder = download
        }
    }
   }



