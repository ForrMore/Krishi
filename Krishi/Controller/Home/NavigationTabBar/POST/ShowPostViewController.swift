//
//  ShowPostViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 30/05/21.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Alamofire

class ShowPostViewController: UIViewController {
    
    private var storage = Storage.storage().reference()
    
    @IBOutlet var commodityImage: UIImageView!
    @IBOutlet var userLocation: UILabel!
    @IBOutlet var varityName: UILabel!
    @IBOutlet var showOption: UILabel!
    @IBOutlet var unitQuantity: UILabel!
    @IBOutlet var expectedPrice: UILabel!
   
    var createimageUid = CreateImageUniqueID()
    var processData = [String:String]()
    let CREATE_SELLER_POST = K.ip+"krishi_app/v1/sell.php"
    let CREATE_BUYER_POST = K.ip+"krishi_app/v1/buy.php"
    var url : String{
        if processData["process"] == "SELL"{
            let url = CREATE_SELLER_POST
            return url
        }else{
            let url = CREATE_BUYER_POST
            return url
        }
    }
    var urlString: String?
    
    let userDefaults = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOption.isHidden = false
        updateView()
    }
    

    
    func updateView(){
        
        expectedPrice.text = "₹ "+processData["expectedPrice"]!+"/"+processData["unitQuantity"]!
        if processData["process"] == "SELL"{
            commodityImage.image = UIImage.init(named: "AddImageCommodity.png")
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            commodityImage.isUserInteractionEnabled = true
            commodityImage.addGestureRecognizer(tapGestureRecognizer)
        }
        else{
            commodityImage.image = UIImage.init(named: processData["commodity"]!+".jpg")
        }
        unitQuantity.text = processData["productQuantity"]!+"/"+processData["unitQuantity"]!
        if processData["inOption"] != ""{
            showOption.text = " "+processData["inOption"]!+" "
        }else{
            showOption.isHidden = true
        }
        if processData["varity"] != ""{
            varityName.text = processData["varity"]!
        }else{
            varityName.text = processData["commodity"]!
        }
        let state = userDefaults.getUserDefaults("State") as! String
        let district = userDefaults.getUserDefaults("District") as! String
        let taluka = userDefaults.getUserDefaults("Taluka") as! String
        
        userLocation.text = state+" | "+district+" | "+taluka
    }
    
    
    
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        //Sending http post request
        let parameters : Parameters = [
            "user_id" : userDefaults.getUserDefaults("ID"),
            "commodity": String(processData["commodity"]!),
            "variety": processData["varity"] ?? "",
            
            "expected_price": String(processData["expectedPrice"]!),
            "quantity": String(processData["productQuantity"]!),
            "unit": String(processData["unitQuantity"]!),
            
            "product_description": String(processData["productDescription"]!),
            "commodity_type": String(processData["inOption"]!),
            "post_date": String(DateTimeManager().currentDate),
            "post_time": String(DateTimeManager().currentTime),
            "commodity_image_link": urlString ?? "null"
        ]

        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            print(response)
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                let error = jsonData.value(forKey: "error") as! Int
                if error == 0{
                    self.drawView()
                }else{
                    let message = "Wait server is not on try after some time"
                    self.showAlert(message)
                }
            }
        }
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func drawView() {
        
        let View = PostCreatedView.commonInit()
        
        View.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(View)
    }
}


//MARK: - image picker
extension ShowPostViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.checkCameraPermission()

    }


    func presentCameraSetting(){
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera Ascess is denied ",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:]) { _ in

                }
            }
        }))
        present(alertController, animated: true)
    }


    func checkCameraPermission(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .denied:
            print("denied status called")
            self.presentCameraSetting()
            break
        case .restricted:
            print("user Dont allow")
            break
        case .authorized:
            print("sucess")
            self.callCamera()
            break

        case .notDetermined:
            print("not determined")
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success{
                    print("primission granted")

                }else{
                    print("permission not granted")
                }
            }
            break

        }
    }


    func callCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        commodityImage.image = image
        let uniqueImageName = (processData["commodity"] ?? "commodity")+createimageUid.createUniqueImageID()

        guard  let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        storage.child("sellCommodityImages/\(uniqueImageName).jpeg").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("failed to upload")
                return
            }

            self.storage.child("sellCommodityImages/\(uniqueImageName).jpeg").downloadURL(completion: { (url, error) in
                self.urlString = String(url!.absoluteString)
                while true{
                    if self.urlString == nil{
                        
                        self.indicator()
                    }else{
                        self.indicatorStop()
                        break
                    }
                }
            })
        }
        dismiss(animated:true, completion: nil)
    }
    func indicator(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    func indicatorStop(){
        dismiss(animated: false, completion: nil)
    }
}



