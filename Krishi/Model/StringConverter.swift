//
//  stringConverter.swift
//  Krishi
//
//  Created by Prashant Jangid on 27/05/21.
//

import Foundation

struct StringConverter {
    func stringToArray(_ string : String?) -> [String]{
        if let str = string{
            var realArray = [String]()
            let array = str.components(separatedBy: "_")
            for i in array{
                if i.count == 0 || realArray.contains(i){
                    continue
                }else{
                    realArray.append(i)
                }
            }
            return realArray
        }
        return ["0"]
    }
    
    func arrayToString(_ array : [String]?) -> String{
        if let array:[String] = array{
            let string = array.joined(separator: "_")
            return string
        }
        return "1"
    }
    
    func convertDateToDate(_ str : String?) -> [String]{
        if let str = str{
            var arr = [String]()
            arr = str.components(separatedBy: "-")
            return arr
        }
        return ["0"]
    }
}
