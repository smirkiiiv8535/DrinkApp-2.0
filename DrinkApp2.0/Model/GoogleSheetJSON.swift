//
//  GoogleSheetJSON.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/15.
//

import Foundation


struct GoogleSheetJSON :Codable{
    var feed: sheetFeed
}

struct sheetFeed:Codable {
    var entry: [needParseDrinkSheet]
}


struct needParseDrinkSheet:Codable{
            var drinkName:MenuDataText
            var mediumPrice:MenuDataText
            var drinkPicture:MenuDataText
            var description:MenuDataText
    
        enum CodingKeys: String, CodingKey {
            case drinkName = "gsx$drinkname"
            case mediumPrice = "gsx$mediumprice"
            case drinkPicture = "gsx$drinkpicture"
            case description = "gsx$description"
         }
    
}

struct MenuDataText:Codable {
    var text:String
    enum CodingKeys: String, CodingKey {
        case text = "$t"
     }
}
