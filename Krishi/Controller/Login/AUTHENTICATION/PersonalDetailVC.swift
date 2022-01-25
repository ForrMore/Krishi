import UIKit

class PersonalDetailVC: UIViewController {
    
    // variabel
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    var userDataDictionary = [String:String]()
    
    
    //MARK: - didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.delegate = self
        lastName.delegate = self
    }
    
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let username = firstName.text!+" "+lastName.text!
        if username.count <= 1{
            let message = "Please enter your First and Last name!"
            showAlert(message)
        }else{
            userDataDictionary["username"] = username
            performSegue(withIdentifier: K.GoTo.currentLocation, sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CurrentLocationVC
        destinationVC.userDataDictionary = userDataDictionary
    }
    
    // show alert
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - delegate method
extension PersonalDetailVC : UITextFieldDelegate{
    // hide kyeboard when tap out side
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
