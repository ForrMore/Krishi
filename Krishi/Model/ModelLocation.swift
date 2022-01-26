//
//  ModelLocation.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation

struct ModelLocation: Codable {
    let allStates: [String]
    let stateData: ModelStateData
}

struct ModelStateData: Codable {
    let state: ModelState
}

struct ModelState: Codable {
    let alldistricts: [String]
    let districtData: DistrictData
}

struct DistrictData: Codable {
    let district: [String]
}
