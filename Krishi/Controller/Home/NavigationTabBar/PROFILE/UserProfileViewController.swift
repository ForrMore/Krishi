
import UIKit
import AVFoundation
import FirebaseStorage
import Alamofire

class UserProfileViewController: UIViewController {

    
    var userData = UserData()
    var stringConverter = StringConverter()
    var commodityArray = [String]()
    var createimageUid = CreateImageUniqueID()
    let profileUpdateUrl = K.ip+"krishi_app/v1/set_userprofile_photo.php"
    
    private var storage = Storage.storage().reference()

    @IBOutlet var cameraView: UIButton!
    @IBOutlet var commodityView: UIView!
    @IBOutlet var changeCommodityButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var userProfilePhoto: UIImageView!
    @IBOutlet var commodityCollectionView: UICollectionView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userMobileNumber: UILabel!
    @IBOutlet var userLocation: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: "updatePrfileData"), object: nil)
        
        commodityCollectionView.delegate = self
        commodityCollectionView.dataSource = self
        updateData()
        commodityCollectionView.register(UINib(nibName: "CommodityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommodityCollectionViewCell")
        updateView()
    }
    
    // changeMobileNumber : - button pressed
    @IBAction func chnageMobileNumberPressed(_ sender: UIButton) {
        showAlertAction("Do u really want to change mobile number!")
    }
    
    
    @objc func updateData(){
       
        userName.text = userData.getUserDefaults("UserName") as? String
        userMobileNumber.text = userData.getUserDefaults("Mobile") as? String
        let state = userData.getUserDefaults("State") as? String
        let district = userData.getUserDefaults("District") as? String
        let taluka = userData.getUserDefaults("Taluka") as? String
        userLocation.text = state!+" | "+district!+" | "+taluka!
        let commodityString = userData.getUserDefaults("userCommodity") as! String
        commodityArray = stringConverter.stringToArray(commodityString)
        commodityCollectionView.reloadData()
    }
    
    func hitApi(_ urlString: String){
        print(urlString)
        let param : Parameters = [
            "user_id" : userData.getUserDefaults("ID"),
            "mobile" : userData.getUserDefaults("Mobile"),
            "userprofile_image_link" : urlString
        ]
        Alamofire.request(profileUpdateUrl, method: .post, parameters: param).responseJSON { response in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                let error = jsonData.value(forKey: "error") as! Int
                if error == 0{
                    print("done")
                }else{
                    print("error")
                }
            }
        }
    }
    
    
    func updateView(){
        commodityView.layer.cornerRadius = 5
        editButton.layer.cornerRadius = 5
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.bounds.height/2
        userProfilePhoto.layer.borderWidth = 3
        userProfilePhoto.layer.borderColor = UIColor.white.cgColor
        cameraView.layer.cornerRadius = cameraView.bounds.height/2
        cameraView.layer.borderWidth = 3
        cameraView.layer.borderColor = UIColor.systemGray5.cgColor
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String, let url = URL(string: urlString) else {
            return
        }
       
       let task =  URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.userProfilePhoto.image = image
            }
            
       }
        task.resume()
    }
    
    
    func showAlertAction(_ message:String){
        let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        //ok button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
           
            //
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
            self.navigationController?.pushViewController(newView, animated: true)
            
        }
        
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
}



//MARK: - collection view delgate and datasource 
extension UserProfileViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commodityArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = commodityCollectionView.dequeueReusableCell(withReuseIdentifier: "CommodityCollectionViewCell", for: indexPath) as? CommodityCollectionViewCell

        let commoName = commodityArray[indexPath.row]
        print(commoName)
        cell?.commodityImage.image = UIImage.init(named: commoName+".jpg")
        cell?.commodityName.text = commodityArray[indexPath.row]

        return cell!

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           return CGSize(width: collectionView.frame.height-20, height: collectionView.frame.height-20)
       }
}


//MARK: - image picker
extension UserProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBAction func openCameraButton(sender: UIButton) {
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
        userProfilePhoto.image = image
        let uniqueImageName = userData.getUserDefaults("UserName") as! String+createimageUid.createUniqueImageID()
        
        
        guard  let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        storage.child("images/\(uniqueImageName).jpeg").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("failed to upload")
                return
            }
            
            self.storage.child("images/\(uniqueImageName).jpeg").downloadURL(completion: { (url, error) in
                let urlString: String = url!.absoluteString
                UserDefaults.standard.set(urlString, forKey: "url")
                DispatchQueue.main.async {
                    self.hitApi(urlString)
                }
            })
        }
        dismiss(animated:true, completion: nil)
    }
}
