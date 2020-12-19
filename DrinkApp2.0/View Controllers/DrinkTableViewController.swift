//
//  DrinkTableViewController.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/16.

import UIKit

class DrinkTableViewController: UITableViewController {

    var allDrinks = [needParseMenuSheet]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let url = URL(string:UrlRequestTask.shared.spreadSheetMenuLink){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data , let drinkData = try? JSONDecoder().decode(GoogleMenuSheetJSON.self, from: data){
                    
                    self.allDrinks = drinkData.feed.entry
                       DispatchQueue.main.async {
                             self.tableView.reloadData()
                         }
                }
            }.resume()
        }
    
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDrinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showDrink = allDrinks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)as?DrinkTableViewCell
        cell?.drinkImage.image = UIImage(named: "kebuke")
        cell?.drinkName.text = "\(showDrink.drinkName.text)"
        cell?.drinkDescription.text = "\(showDrink.description.text)"
        
        if let imageURL = URL(string: showDrink.drinkPicture.text){
              URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                   if let data = data {
                           DispatchQueue.main.async {
                              cell?.drinkImage.image = UIImage(data: data)
                       }
                   }
        }.resume()
      }
        return cell!
    }
}
