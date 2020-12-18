//
//  CanEditData.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/18.
//

import Foundation


struct CanEditData:Codable{
        var name :String
        var drink:String
        var chooseSugar :String
        var chooseIce:String
        var chooseSize:String
        var haveBubble:String
        var price :Int
        var pictureLink:String
}



struct PutDataToSheetDB:Codable{
    var data :[CanEditData]
}
