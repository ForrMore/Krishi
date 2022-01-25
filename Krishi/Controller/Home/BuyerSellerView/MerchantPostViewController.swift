//
//  MerchantPostViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import UIKit
import Alamofire

class MerchantPostViewController: UIViewController {
    
    var merchant_type : String?
    let URL_ADD_CONTACTS = K.ip+"krishi_app/v1/user_contacts.php"
    let process: String? = nil
    
    @IBOutlet var postView: UIView!
    @IBOutlet var merchantPhoto: UIImageView!
    @IBOutlet var merchantCommodityName: UILabel!
    @IBOutlet var merchantdDescription: UILabel!
    @IBOutlet var saveContactButton: UIButton!
    @IBOutlet var merchantLocation: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var expectedPrice: UILabel!
    @IBOutlet var merchantImage: UIImageView!
    @IBOutlet var merchantName: UILabel!
    @IBOutlet var quantityWithUnit: UILabel!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var contactButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        if merchant_type == "seller"{
            processSeller()
        }else{
            processBuyer()
        }
        
    }
    
    func processSeller(){
        
        self.merchantName.text = SellPostHelper.shared.merchantData?.username
        self.merchantLocation.text = SellPostHelper.shared.merchantData!.state+" | "+SellPostHelper.shared.merchantData!.district+" | "+SellPostHelper.shared.merchantData!.taluka
        self.merchantCommodityName.text = SellPostHelper.shared.merchantData?.commodity
        self.merchantdDescription.text = SellPostHelper.shared.merchantData?.product_description
        self.expectedPrice.text = SellPostHelper.shared.merchantData!.expected_price+"/"+SellPostHelper.shared.merchantData!.unit
        self.quantityWithUnit.text = SellPostHelper.shared.merchantData!.quantity+"/"+SellPostHelper.shared.merchantData!.unit
        self.postDate.text = SellPostHelper.shared.merchantData?.post_date
        
        let urlString = SellPostHelper.shared.merchantData?.commodity_image_link
        if urlString == "null" || urlString == nil{
            self.merchantImage.image = UIImage(named: SellPostHelper.shared.merchantData!.commodity+".jpg")
        }else{
            let url = URL(string: urlString!)
            
            let task =  URLSession.shared.dataTask(with: url!) { (data,_, error) in
                guard let data = data, error == nil else{
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.merchantImage.image = image
                }
            }
            task.resume()
        }
        
    }
    
    func processBuyer(){
            self.merchantName.text = helper.shared.merchantData?.username
            self.merchantLocation.text = helper.shared.merchantData!.state+" | "+helper.shared.merchantData!.district+" | "+helper.shared.merchantData!.taluka
            self.merchantCommodityName.text = helper.shared.merchantData?.commodity
            self.merchantdDescription.text = helper.shared.merchantData?.product_description
            self.expectedPrice.text = helper.shared.merchantData!.expected_price+"/"+helper.shared.merchantData!.unit
            self.quantityWithUnit.text = helper.shared.merchantData!.quantity+"/"+helper.shared.merchantData!.unit
            self.postDate.text = helper.shared.merchantData?.post_date
        self.merchantImage.image = UIImage(named: helper.shared.merchantData!.commodity+".jpg")
    }
    
    func updateView(){
        postView.layer.cornerRadius = 10
        merchantPhoto.layer.cornerRadius = merchantPhoto.bounds.height/2
        saveContactButton.layer.borderWidth = 2
        saveContactButton.layer.borderColor = UIColor.init(named: K.BrandColor.accentColor)?.cgColor
        saveContactButton.layer.cornerRadius = 5
        callButton.layer.cornerRadius = 5
        contactButton.layer.cornerRadius = contactButton.bounds.height/2
        saveContactButton.setTitle("Save to contacts as buyer",for: .normal)
        contactButton.layer.borderColor = UIColor.black.cgColor
        contactButton.layer.borderWidth = 2
        contactButton.layer.shadowPath = UIBezierPath(rect: contactButton.bounds).cgPath
        contactButton.layer.shadowRadius = contactButton.bounds.height/2
        contactButton.layer.shadowOffset = .zero
        contactButton.layer.shadowOpacity = 0.3
        
    }
    
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        if merchant_type == "seller" {
            if let phoneUrl = URL(string: "tel://"+SellPostHelper.shared.merchantData!.mobile){
                if UIApplication.shared.canOpenURL(phoneUrl){
                    UIApplication.shared.open(phoneUrl ,options:[:],completionHandler: nil)
                }else{
                    showAlert("mobile number does not exist")
                }
            }
        }else{
            if let phoneUrl = URL(string: "tel://"+helper.shared.merchantData!.mobile){
                if UIApplication.shared.canOpenURL(phoneUrl){
                    UIApplication.shared.open(phoneUrl ,options:[:],completionHandler: nil)
                }else{
                    showAlert("mobile number does not exist")
                }
            }
        }
        
    }
    
    
    @IBAction func saveContactButtonPressed(_ sender: UIButton) {
        if merchant_type == "seller"{
            let parameters : Parameters = [
                "user_id" : UserData().getUserDefaults("ID"),
                "merchant_name" : SellPostHelper.shared.merchantData!.username,
                "merchant_mobile" : SellPostHelper.shared.merchantData!.mobile,
                "merchant_type" : self.merchant_type!,
                "process" : "create"
            ]
            hitApi(parameters)
        }else{
            let parameters : Parameters = [
                "user_id" : UserData().getUserDefaults("ID"),
                "merchant_name" : helper.shared.merchantData!.username,
                "merchant_mobile" : helper.shared.merchantData!.mobile,
                "merchant_type" : self.merchant_type!,
                "process" : "create"
            ]
            hitApi(parameters)
        }
    }
    
    func hitApi(_ param : Parameters){
        
        Alamofire.request(URL_ADD_CONTACTS, method: .post, parameters: param).responseJSON{ [self]
            response in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                let error = jsonData.value(forKey: "error") as! Int
                let message = jsonData.value(forKey: "message") as! String
                if error == 0{
                    self.showAlert(message)
                }else{
                    self.showAlert(message)
                }
            }else{
                showAlert("error")
            }
        }
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
