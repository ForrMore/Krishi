

import UIKit
import Alamofire

class VCOtp: UIViewController {
    
    
    //MARK: - Variables
    
    var userMobileNumber : String = ""
    var URL_VERIFY_AUTH = K.Url.verifyUser
    var existedUser : NSDictionary?
    
    var userData = UserData()
    
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        
        otpTextField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func resendOtpButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        let otp = otpTextField1.text! + otpTextField2.text! + otpTextField3.text! + otpTextField4.text!
        let parameters: Parameters = [
            "mobile":userMobileNumber,
            "otp":otp
        ]
        if otp.count < 4{
            let message = "Please enter your valid 4-digit OTP sent on ur mobile number!"
            showAlert(message)
        }else{
            //Sending http post request
            Alamofire.request(URL_VERIFY_AUTH, method: .get, parameters: parameters).responseJSON{
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    print(jsonData,"-------")
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    if error == 0{
                        if jsonData.value(forKey: "userExist") as! Int == 0{
                            self.existedUser =  self.convertStringToDictionary(text: jsonData.value(forKey: "data") as! String) as NSDictionary?
                            
                            //set data to defaults
                            self.userData.setUserDefaults(self.existedUser!)
                            
                            
                            self.performSegue(withIdentifier: K.GoTo.homeScreenVC, sender: self)
                        }else{
                            self.performSegue(withIdentifier: K.GoTo.personalDetailVC, sender: self)
                        }
                    }else{
                        let message = "Type correct OTP!"
                        self.showAlert(message)
                    }
                }
            }
        }
    }
    // convert json string to dictionary 
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    //prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userDataDictionary:[String:String] = [
            "mobile":userMobileNumber
        ]
        if segue.identifier == K.GoTo.personalDetailVC{
            let destinationVC = segue.destination as! PersonalDetailVC
            destinationVC.userDataDictionary = userDataDictionary
        }
    }
    
    // show alert
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // not impp
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otpTextField1:
                otpTextField1.becomeFirstResponder()
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    //
}

extension VCOtp : UITextFieldDelegate{
    //    hide kyeboard when tap out side
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

