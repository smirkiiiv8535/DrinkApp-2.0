//
//  Order.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/15.
//
//
import Foundation


struct List:Codable {
    var data : Order
}


struct Order:Codable{
    var name :String
    var drink:String
    var chooseSugar :String
    var chooseIce:String
    var chooseSize:String
    var haveBubble:String
    var price :Int
    var pictureLink:String
}


