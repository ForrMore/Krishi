//
//  JsonParser.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation
import UIKit

enum ParserError: Error {
    case parsingError(typeofError: Error)
}

class JSONParser: NSObject{
    static let shared = JSONParser()
    
    class func JsonParser<T: Codable>(fileName:String,toModel:T.Type) throws -> T?{
        let result: T?
        guard let path = Bundle.main.path(forResource: fileName, ofType: K.jsonFileName[1])else {return nil}
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(toModel.self ,from: jsonData) as T
        }catch{
            throw ParserError.parsingError(typeofError: error)
        }
        return result
    }
}

