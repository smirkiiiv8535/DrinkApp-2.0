//
//  GoogleMenuSheetJSON.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/15.
//

import Foundation


 struct GoogleMenuSheetJSON :Codable{
    var feed: sheetMenuFeed
}

 struct sheetMenuFeed:Codable {
    var entry: [needParseMenuSheet]
}


struct needParseMenuSheet:Codable{
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
