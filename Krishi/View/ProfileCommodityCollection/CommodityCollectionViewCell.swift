//
//  CommodityCollectionViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit

class CommodityCollectionViewCell: UICollectionViewCell {

    @IBOutlet var commodityImage: UIImageView!
    @IBOutlet var commodityName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commodityImage.layer.cornerRadius = commodityImage.bounds.height/2
        commodityImage.layer.borderWidth = 2
        commodityImage.layer.borderColor = UIColor.white.cgColor
        commodityImage.layer.shadowRadius = commodityImage.bounds.height/2
        commodityImage.layer.shadowColor = UIColor.black.cgColor
        commodityImage.layer.shadowOffset = .zero
        commodityImage.layer.shadowRadius = 1
    }

}
