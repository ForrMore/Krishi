//
//  ContactsModel.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import Foundation

struct ContactsModel : Codable {
    let data : [Contacts]
    let data_exist : Int
    let error : Bool
}

struct Contacts : Codable {
    
    let merchant_name : String
    let merchant_mobile : String
    let merchant_type : String
   
}
