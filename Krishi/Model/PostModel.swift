//
//  UserPostModel.swift
//  Krishi
//
//  Created by Prashant Jangid on 01/06/21.
//

import Foundation

struct PostData : Codable {
    let data : [Posts]
    let data_exist : Int
    let error : Bool
}

struct Posts : Codable {
    
    let post_id : Int
    let user_id : Int
    let username : String
    let mobile : String
    let state : String
    let district : String
    let taluka : String
    let commodity : String
    let variety : String
    let expected_price : String
    let quantity : String
    let unit : String
    let product_description : String
    let commodity_type : String
    let post_date : String
}
