//
//  DateTimeManager.swift
//  Krishi
//
//  Created by Prashant Jangid on 31/05/21.
//

import Foundation


struct DateTimeManager{

    let date = Date()
    let formattor = DateFormatter()
    
    
    var weatherDate : String {
        formattor.dateFormat = "EEEE , d MMM yyyy"
        return formattor.string(from: date)
    }
    
    var currentDate : String {
        formattor.dateFormat = "yyyy-MM-dd"
        return formattor.string(from: date)
    }
    
    var currentTime : String {
        formattor.dateFormat = "HH:mm:ss.SSS"
        return formattor.string(from: date)
    }
    
    var currentDateTime : String{
        formattor.dateFormat = "yy-MM-dd, HH:mm"
        return formattor.string(from: date)
    }
}
