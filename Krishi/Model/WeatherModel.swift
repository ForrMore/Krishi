//
//  WeatherModel.swift
//  Clima
//
//  Created by Prashant Jangid on 25/04/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    let cityName : String
    let conditionId : Int
    let temperature : Double
    let min_temperature : Double
    let max_temperature : Double
    let humadity : Int
    let wind : Double
    let description : String
    
    
    var temperatureString : String{
        return String(format: "%.1f" , temperature)+"˚C"
    }
    var min_temperatureString : String{
        return String(format: "%.1f" , min_temperature)+"˚C"
    }
    var max_temperatureString : String{
        return String(format: "%.1f" , max_temperature)+"˚C"
    }
    var descriptionString : String{
        return " "+description+" "
    }
    
    var conditionName : String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
