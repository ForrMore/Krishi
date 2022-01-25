//
//  ContactTableViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 03/06/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var merchantTypeLabel: UILabel!
    @IBOutlet var merchantName: UILabel!
    @IBOutlet var merchantMobile: UILabel!
    @IBOutlet var deleteContact: UIButton!
    
    var yourobj : (() -> Void)? = nil
    var deleteobj : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func viewUpdate(){
        merchantTypeLabel.layer.cornerRadius = merchantTypeLabel.bounds.height/2
        cellView.layer.cornerRadius = 10
    }
    
    func merchantTypeView(_ str : String){
        if str == "buyer"{
            merchantTypeLabel.text = "Buyer"
            merchantTypeLabel.backgroundColor = UIColor.systemOrange
        }else{
            merchantTypeLabel.backgroundColor = UIColor.systemYellow
            merchantTypeLabel.text = "Seller"
        }
    }
    @IBAction func callButtonPressed(_ sender: Any) {
        if let btnAction = self.yourobj{
            btnAction()
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let btnAction = self.deleteobj{
            btnAction()
        }
    }
    
    
}
