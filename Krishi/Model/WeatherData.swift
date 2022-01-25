//
//  DataManager.swift
//  Clima
//
//  Created by Prashant Jangid on 25/04/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {//  Codable is an allias of (Decodable,Encodable)
    let name : String
    let weather : [Weather]
    let main : Main
    let wind : Wind
}

struct Weather : Codable {
    let main : String
    let id : Int
    let description : String
}

struct Main : Codable {
    let temp: Double
    let temp_min : Double
    let temp_max :Double
    let humidity : Int
}

struct Wind : Codable{
    let speed : Double
}
