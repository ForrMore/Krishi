//
//  Ext-UIView.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation
import UIKit

class ViewTopCorner8: UIView{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.clipsToBounds = true
        roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func removeWithAnimate(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    
    func hideWithAnimate(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
}
