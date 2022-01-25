//
//  UserContactsViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import UIKit
import Alamofire
import SwipeCellKit

class UserContactsViewController: UIViewController {

    @IBOutlet var noResultView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var result : ContactsModel?
    let URl_GET_CONTACTS = K.ip+"krishi_app/v1/get_user_contacts.php"
    let deleteContacts = K.ip+"krishi_app/v1/user_contacts.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        
        hitApi()
       
    }
    
    func hitApi(){
        
        let parameters : Parameters = [
            "user_id" : UserData().getUserDefaults("ID")
        ]
        
        Alamofire.request(URl_GET_CONTACTS, method: .get, parameters: parameters).responseJSON{ [self]
            response in
   
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    result = try decoder.decode(ContactsModel.self, from: data)
                    if result?.error == false{
                        
                        if result?.data_exist != 0{
                            self.tableView.isHidden = false
                            self.noResultView.isHidden = true
                            self.tableView.reloadData()
                        }else {
                            self.noResultView.isHidden = false
                            self.tableView.isHidden = true
                            self.tableView.reloadData()
                        }
                    }else{
                        print("error")
                    }
                }catch{
                    print("error\(error)")
                }
            }
        }
    }
    
}

extension UserContactsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
       
        cell.yourobj = { [self] in
            if let phoneUrl = URL(string: "tel://"+(result?.data[indexPath.row].merchant_mobile)!){
                if UIApplication.shared.canOpenURL(phoneUrl){
                    UIApplication.shared.open(phoneUrl ,options:[:],completionHandler: nil)
                }else{
                    self.showAlert("mobile number does not exist")
                }
            }
        }
        
        cell.deleteobj = {
            let parameters : Parameters = [
                "user_id" : UserData().getUserDefaults("ID"),
                "merchant_type":(self.result?.data[indexPath.row].merchant_type)!,
                "merchant_name":(self.result?.data[indexPath.row].merchant_name)!,
                "merchant_mobile" : (self.result?.data[indexPath.row].merchant_mobile)!,
                "process" : "delete"
            ]
            self.showAlertAction("Do you really want to delete contact!",parameters)
            
        }
        
        cell.merchantName.text = result?.data[indexPath.row].merchant_name
        cell.merchantMobile.text = "+91 "+(result?.data[indexPath.row].merchant_mobile)!
        cell.viewUpdate()
        cell.merchantTypeView((result?.data[indexPath.row].merchant_type)!)
        
        return cell
    }
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAction(_ message:String ,_ param : Parameters){
        let alert = UIAlertController(title: "Delete Contact", message: message, preferredStyle: UIAlertController.Style.alert)
       
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler: { (UIAlertAction) in
            
            Alamofire.request(self.deleteContacts, method: .post, parameters: param).responseJSON{ [self]
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    if error == 0{
                        hitApi()
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }else{
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
    
    

