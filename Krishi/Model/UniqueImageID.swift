//
//  UniqueImageID.swift
//  Krishi
//
//  Created by Prashant Jangid on 13/07/21.
//

import Foundation

class CreateImageUniqueID {
    var letters = ["q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"]
    var symbols = ["!","@","#","$","%","&"]
    var imageUid : String = ""
    
    func createUniqueImageID() -> String {
        var arr = [String]()
        for _ in Range(0...5){
            arr.append(letters[Int.random(in: 0..<25)])
            arr.append(symbols[Int.random(in: 0..<5)])
        }
        arr.shuffle()
        for string in arr.shuffled(){
            imageUid += string
        }
        return imageUid
    }
}
