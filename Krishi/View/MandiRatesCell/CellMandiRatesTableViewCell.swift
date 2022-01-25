//
//  CellMandiRatesTableViewCell.swift
//  Krishi
//
//  Created by Prashant Jangid on 06/06/21.
//

import UIKit

class CellMandiRatesTableViewCell: UITableViewCell {

    @IBOutlet var commodityNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commodityQuantityLabel: UILabel!
    @IBOutlet var commodityMinRateLabel: UILabel!
    @IBOutlet var commodityMaxRateLabel: UILabel!
    @IBOutlet var commodityModalRateLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UIViewUpdate(){
        mainView.layer.cornerRadius = 8
        mainView.layer.shadowOpacity = 1
        topView.layer.cornerRadius = 8
        let red = Float.random(in: 150...164)
        let green = Float.random(in: 164...200)
        let blue = Float.random(in: 200...215)
        topView.backgroundColor = UIColor.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
    }
    
}
