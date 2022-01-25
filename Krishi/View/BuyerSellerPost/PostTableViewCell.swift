//
//  PostTableViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet var commodityImage: UIImageView!
    @IBOutlet var userLocation: UILabel!
    @IBOutlet var commodityName: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var commodityType: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var postView: UIView!
    @IBOutlet var merchantType: UILabel!
    @IBOutlet var merchantName: UILabel!
    @IBOutlet var newLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func viewUpdate(){
        merchantType.layer.borderWidth = 2
        merchantType.layer.borderColor = UIColor.init(named: K.BrandColor.lightGreen)?.cgColor
        merchantType.layer.cornerRadius = merchantType.bounds.height/2
        
        postView.layer.cornerRadius = 10
    }
}
