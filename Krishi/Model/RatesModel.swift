//
//  RatesModel.swift
//  Krishi
//
//  Created by Prashant Jangid on 06/06/21.
//

import Foundation

struct RatesModel : Codable {
    let records : [RecordsData]
    
//    private enum CodingKeys : String,CodingKey{
//        case records = "results"
//    }
}

struct RecordsData : Codable {
    let timestamp : String
    let state : String
    let district : String
    let market : String
    let commodity : String
    let variety : String
    let arrival_date : String
    let min_price : String
    let max_price : String
    let modal_price : String
    
//    private enum CodingKeys : String,CodingKey{
//        case timestamp = "time_stamp"
//        case state = "state"
//        case district = "district"
//        case market = "market"
//        case commodity = "commodity"
//        case variety = "variety"
//        case arrival_date = "arival_data"
//        case min_price = "minimum_price"
//        case max_price = "maximum_price"
//        case modal_price = "modal_price"
//    }
}

