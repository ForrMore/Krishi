//
//  unitCollectionViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 30/05/21.
//

import UIKit

class unitCollectionViewCell: UICollectionViewCell {
    @IBOutlet var unitLabel: UILabel!
 
    func updateView(){
        unitLabel.layer.cornerRadius = unitLabel.bounds.height/2
        unitLabel.backgroundColor = UIColor.white
        unitLabel.layer.borderWidth = 2
        unitLabel.layer.borderColor = UIColor.init(named: K.BrandColor.darkGreen)?.cgColor
    }
}
