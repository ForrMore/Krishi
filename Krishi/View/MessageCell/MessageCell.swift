//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Prashant Jangid on 26/04/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit
import  Firebase

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var lebel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    var trailingConstraint,leadingConstraint,a,b: NSLayoutConstraint!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        lebel.text = nil
        trailingConstraint.isActive = false
        leadingConstraint.isActive = false
        a.isActive = false
        b.isActive = false
        
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellViewUpdate(by message : Messages){
        messageBubble.layer.cornerRadius = 16
        messageBubble.clipsToBounds = true
        trailingConstraint = messageBubble.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstraint = messageBubble.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        a = nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        b = nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        if message.sender == UserData().getUserDefaults("Mobile") as! String{
            
            messageBubble.backgroundColor = UIColor(named: K.BrandColor.accentColor)
            lebel.textColor = UIColor.white
            nameLabel.textAlignment = .right
            a.isActive = true
            trailingConstraint.isActive = true
            lebel.textAlignment = .right
            dateTimeLabel.textAlignment = .right
            nameLabel.isHidden = true
            dateTimeLabel.textColor = UIColor.black
            
        }else{
            
            messageBubble.backgroundColor = UIColor(named: K.BrandColor.lightGreen)
            lebel.textColor =  UIColor.black
            nameLabel.textAlignment = .left
            lebel.textAlignment = .left
            
            leadingConstraint.isActive = true
            b.isActive = true
            dateTimeLabel.textAlignment = .left
            dateTimeLabel.textColor = UIColor.darkGray
        }
    }
}
