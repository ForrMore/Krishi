//
//  Instance.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation
import UIKit

class Instance: NSObject{
    static let shared = Instance()
    static var height: CGFloat = 0.0
    static var width: CGFloat = 0.0
    static var frame = CGRect()
}
