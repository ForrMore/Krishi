//
//  helper.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import Foundation

class helper: NSObject {
  
    static let shared = helper()
    var merchantData : Posts?
}

class SellPostHelper : NSObject {
  
    static let shared = SellPostHelper()
    var merchantData : SellPosts?
}
