//
//  Ext-UIButton.swift
//  Krishi
//
//  Created by MacBook on 25/01/22.
//

import Foundation
import UIKit


class BtnCorner: UIButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.layer.cornerRadius = 4
    }
}
