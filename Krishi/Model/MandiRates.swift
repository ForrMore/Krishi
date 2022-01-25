//
//  MandiRates.swift
//  Krishi
//
//  Created by Prashant Jangid on 06/06/21.
//

import Foundation
import Alamofire

class MandiRates{
    
    private let parameters : Parameters?
    var result : RatesModel?
    var mandidata : [RecordsData]?
    
    private let ENDPOINT_API = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070"
    private let API_KEY = "579b464db66ec23bdd00000143e218da3e65477c650a4661ce9e9d49"
    
    init() {
        self.parameters = [
            "api-key" : self.API_KEY,
            "format" : "json",
            "offset" : 0,
            "limit" :  10000,
        ]
        hitApi()
    }
    
    func hitApi(){
        
        Alamofire.request(ENDPOINT_API, method: .get, parameters: self.parameters).responseJSON{ [self]
            response in
   
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    self.result = try decoder.decode(RatesModel.self, from: data)
                }catch{
                    print("error\(error)")
                }
            }
        }
        getMandiRates("all", "as", "Maharashtra")
    }
    
    func getMandiRates(_ commodity : String,_ district : String,_ state : String){
        if commodity == "all"{
            for i in result?.records ?? []{
                print(i.commodity)
            }
        }
    }
    
//    func binarySearch(_ arrData : [RecordsData]) -> [RecordsData]?{
//        var lowerIndex = 0
//        var upperIndex = arrData.count - 1
//
//        while (true) {
//            let currentIndex = (lowerIndex + upperIndex)/2
//            if(arrData[currentIndex] == searchItem) {
//                return currentIndex
//            } else if (lowerIndex > upperIndex) {
//                return nil
//            } else {
//                if (inputArr[currentIndex] > searchItem) {
//                    upperIndex = currentIndex - 1
//                } else {
//                    lowerIndex = currentIndex + 1
//                }
//            }
//        }
//    }
}
