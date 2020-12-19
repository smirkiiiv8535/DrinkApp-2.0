//
//  UrlRequestTask.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/15.
//

import Foundation


struct UrlRequestTask{
    static let shared = UrlRequestTask()
    var sheetDBOrderLink = "https://sheetdb.io/api/v1/8spaqdm1dyk9p"
    var spreadSheetOrderLink = "https://spreadsheets.google.com/feeds/list/1UoED_1CmbLXaPRyY-hNWWcgOkVPYsH1xfJ0YH6l94CE/od6/public/values?alt=json"
    var spreadSheetMenuLink = "https://spreadsheets.google.com/feeds/list/1BhDiIRcDRVXw8HA1Yt3fm4HhEmeUI6Vbke-h_oWslPk/od6/public/values?alt=json"
}
