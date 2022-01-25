

import UIKit

class CellCommodity: UITableViewCell {

    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var commodityImage: UIImageView!
    @IBOutlet var commodityName: UILabel!
    var leadingConstraint : NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func viewUpdate(){
        commodityImage.layer.cornerRadius = commodityImage.bounds.width/2
    }
    
    func hideCheckImageView(){
        checkImage.isHidden = true
        leadingConstraint = checkImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20)
        leadingConstraint.isActive = true
    }
}
