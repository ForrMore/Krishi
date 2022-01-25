import UIKit
import Alamofire

class VCLocation: UIViewController {
    
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var talukaField: UITextField!
    
    var userDataDictionary = [String:String]() // A
    var URL_CREATE_USER = K.Url.createUser
    var id_mobile = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting and getting defaults
        let userData = userDataDictionary as NSDictionary
        let userDefaults = UserData() //object create
        userDefaults.userDic = userData
        let mobileNumber = userDefaults.getUserDefaults("Mobile")
        print(mobileNumber)
        //
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {//goToHome
        if stateField.text?.count == 0 && districtField.text?.count == 0 && talukaField.text?.count == 0{
            let message = "Please enter ur State, District, Taluka in above Field! "
            showAlert(message)
        }else{
            userDataDictionary["state"] = stateField.text!
            userDataDictionary["district"] = districtField.text!
            userDataDictionary["taluka"] = talukaField.text ?? ""
//            userDataDictionary[""]
            let parameters: Parameters = userDataDictionary
            
            //Sending http post request
            Alamofire.request(URL_CREATE_USER, method: .post, parameters: parameters).responseJSON{
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    let id = jsonData.value(forKey: "id") as? Int
                    let mobile = Int((jsonData.value(forKey: "mobile") as? String)!)
                    self.id_mobile.append(id!)
                    self.id_mobile.append(mobile!)
                    
                    if error == 0{
                        self.performSegue(withIdentifier: K.GoTo.SelectedCommodity, sender: self)
                    }else{
                        let message = "Complete above data"
                        self.showAlert(message)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! VCCommodity
        destinationVC.userId_userMobile = id_mobile
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - delegate Method for textfield
extension VCLocation : UITextFieldDelegate{
    //hide kyeboard when tap out side
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

