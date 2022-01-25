

import UIKit

@IBDesignable
class ViewDetail: UIView {
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var StateView: UIView!
    @IBOutlet var DistrictView: UIView!
    @IBOutlet var AnyCommodityView: UIView!
    @IBOutlet var UIButtonView: UIButton!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var anyCommodityTextField: UITextField!
    @IBOutlet var statelabel: UILabel!
    @IBOutlet var districtLabel: UILabel!
    @IBOutlet var commodityLabel: UILabel!
    @IBOutlet var districtTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    
    var userData = UserData()
    var stringConverter = StringConverter()
    var commodityArray = [String]()
    
    class func commonInit() -> ViewDetail {
        let nibView = Bundle.main.loadNibNamed("ViewDetail", owner: self, options: nil)?[0] as! ViewDetail
        nibView.layoutIfNeeded()
        return nibView
    }
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CommodityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommodityCollectionViewCell")
    }
    
    override func draw(_ rect: CGRect) {
        viewUpdate(StateView)
        viewUpdate(DistrictView)
        viewUpdate(AnyCommodityView)
        UIButtonView.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        statelabel.isHidden = true
        districtLabel.isHidden = true
        commodityLabel.isHidden = true
        
        let commodityString = userData.getUserDefaults("userCommodity") as! String
        commodityArray = stringConverter.stringToArray(commodityString)
        collectionView.reloadData()
        print(commodityArray)
    }
    
    func viewUpdate(_ vw : UIView){
        vw.layer.cornerRadius = StateView.bounds.height/2
        vw.layer.borderWidth = 2
        vw.layer.borderColor = UIColor.systemGray5.cgColor
        vw.backgroundColor = UIColor.white
        vw.backgroundColor = UIColor.white
    }
}

extension ViewDetail : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let commodityString = userData.getUserDefaults("userCommodity") as! String
        commodityArray = stringConverter.stringToArray(commodityString)
        return commodityArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CommodityCollectionViewCell", for: indexPath) as? CommodityCollectionViewCell

        let commoName = commodityArray[indexPath.row]
        cell?.commodityImage.image = UIImage.init(named: commoName+".jpg")

        return cell!

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           return CGSize(width: collectionView.frame.height-20, height: collectionView.frame.height-20)
       }
}


