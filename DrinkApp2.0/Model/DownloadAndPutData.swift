//
//  DownloadAndPutData.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/17.
//

import Foundation

//
//struct DownloadSheetDbData:Codable{
//        var name :String
//        var drink:String
//        var chooseSugar :String
//        var chooseIce:String
//        var chooseSize:String
//        var haveBubble:String
//        var price :String
//        var pictureLink:String
//}



struct GoogleOrderSheetJSON :Codable{
   var feed: sheetOrderFeed
}

struct sheetOrderFeed:Codable {
   var entry: [needParseOrderSheet]
}


struct needParseOrderSheet:Codable{
           var name:OrderDataText
           var drink:OrderDataText
           var chooseSugar:OrderDataText
           var chooseIce:OrderDataText
           var chooseSize:OrderDataText
           var haveBubble:OrderDataText
           var price:OrderDataText
           var pictureLink:OrderDataText

       enum CodingKeys: String, CodingKey {
           case name = "gsx$name"
           case drink = "gsx$drink"
           case chooseSugar = "gsx$choosesugar"
           case chooseIce = "gsx$chooseice"
           case chooseSize = "gsx$choosesize"
           case haveBubble = "gsx$havebubble"
           case price = "gsx$price"
           case pictureLink = "gsx$picturelink"
        }
}


struct OrderDataText:Codable {
   var text:String
   enum CodingKeys: String, CodingKey {
       case text = "$t"
    }
}
