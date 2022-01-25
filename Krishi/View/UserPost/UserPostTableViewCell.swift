//
//  UserPostTableViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet var commodityImage: UIImageView!
    @IBOutlet var userLocation: UILabel!
    @IBOutlet var commodityName: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var commodityType: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var deleteButtonView: UIButton!
    @IBOutlet var postView: UIView!
    
    var yourobj : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton)
    {
        if let btnAction = self.yourobj{
            btnAction()
        }
    }
  func viewUpdate(){
    deleteButtonView.layer.borderWidth = 2
    deleteButtonView.layer.borderColor = UIColor.init(named: K.BrandColor.accentColor)?.cgColor
    deleteButtonView.layer.cornerRadius = 3
    postView.layer.cornerRadius = 5
    }
}
