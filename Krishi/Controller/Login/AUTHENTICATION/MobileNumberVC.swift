

import UIKit
import Alamofire
import UserNotifications

class MobileNumberVC: UIViewController {
    
    @IBOutlet weak var enterMobileNumber: UITextField!
//        var URL_CREATE_AUTH = "http://192.168.64.2/krishi_app/v1/create_auth.php"
    var URL_CREATE_AUTH = K.Url.createAuth
    
    let notifictionCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        notifictionCenter.delegate = self
        notifictionCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (sucess, error) in
        }
        
        self.enterMobileNumber.delegate = self
    }
}


//MARK: - UItextfieds delegate method

extension MobileNumberVC : UITextFieldDelegate{
    //hide kyeboard when tap out side
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //set max length to textfied
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (enterMobileNumber.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

//MARK: - user Notification

extension MobileNumberVC: UNUserNotificationCenterDelegate{
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        let mobileNumber = enterMobileNumber.text!
        let parameters: Parameters = [
            "mobile":mobileNumber
        ]
        if mobileNumber.count < 10{
            let message = "Please enter your valid mobile 10-digit number!"
            showAlert(message)
        }else{
            //Sending http post request
            Alamofire.request(URL_CREATE_AUTH, method: .post, parameters: parameters).responseJSON{
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    let otp = jsonData.value(forKey: "otp") as! Int
                    if error == 0{
                        self.notifictionCenterCall(String(otp))
                        self.performSegue(withIdentifier: K.GoTo.otpVC, sender: self)
                    }else{
                        let message = "Wait server is not on try after some time"
                        self.showAlert(message)
                    }
                }
            }
        }
    }
    
    func notifictionCenterCall(_ otp: String){
        //Notification content
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category Identifier"
        content.title = "KRISHIOPX"
        content.body = "Your OTP for Krishi App is "+otp+"."
        content.badge = 1
        content.sound = UNNotificationSound.default
        //
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)//timiing
        let indetifier = "Main Identifier"
        let request = UNNotificationRequest.init(identifier: indetifier, content: content, trigger: trigger)
        notifictionCenter.add(request) { (error) in
            print(error?.localizedDescription ?? "error")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.banner,.badge,.sound])
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mobileNumber = enterMobileNumber.text!
        
        let destinationVC = segue.destination as! OtpVC
        destinationVC.userMobileNumber = mobileNumber
    }
}

