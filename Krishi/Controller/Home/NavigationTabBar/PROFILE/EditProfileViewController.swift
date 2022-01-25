//
//  EditProfileViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {
    
    let URL_UPDATE_USER = K.Url.updateUser
    
    var userData = UserData()
    @IBOutlet var userName : UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var taluka: UITextField!
    @IBOutlet var district: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = userData.getUserDefaults("UserName") as? String
        state.text = userData.getUserDefaults("State") as? String
        district.text = userData.getUserDefaults("District") as? String
        taluka.text = userData.getUserDefaults("Taluka") as? String
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if userName.text?.count == 0 || state.text?.count == 0 || district.text?.count == 0{
            print("complete info ")
            showAlert("Please Enter valid Info!")
        }
        else{
            print("herer-----")
            showAlertAction("if saved data appliction will pop u!")
        }
    }
    
    func showAlertAction(_ message:String){
        let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.userData.setDefaults(key: "UserName",data: self.userName.text!)
            self.userData.setDefaults(key: "State",data: self.state.text!)
            self.userData.setDefaults(key: "District",data: self.district.text!)
            self.userData.setDefaults(key: "Taluka",data: self.taluka.text!)
            
            let parameters : Parameters = [
                "id" : self.userData.getUserDefaults("ID"),
                "username" : self.userName.text!,
                "mobile" : self.userData.getUserDefaults("Mobile"),
                "state" : self.state.text!,
                "district" : self.district.text!,
                "taluka" : self.taluka.text!
            ]
            
            //Sending http post request
            Alamofire.request(self.URL_UPDATE_USER, method: .post, parameters: parameters).responseJSON{
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    
                    if error == 0{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePrfileData"), object: nil, userInfo: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
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
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - UItextfieds delegate method

extension EditProfileViewController : UITextFieldDelegate{
    //hide kyeboard when tap out side
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
