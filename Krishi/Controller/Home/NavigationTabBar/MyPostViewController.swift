//
//  MyPostViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 31/05/21.
//

import UIKit
import Alamofire


class MyPostViewController: UIViewController {
    
    @IBOutlet var noResultView: UIView!
    @IBOutlet var noResultImage: UIImageView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var sellButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var userResult: PostData?
    
    let URL_MY_POST = K.ip+"krishi_app/v1/get_user_post.php"
    let DELETE_URL = K.ip+"krishi_app/v1/delete_post.php"
    let userDefaults = UserData()
    var buyprocess : Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 175
        
        
        tableView.register(UINib(nibName: "UserPostTableViewCell", bundle: nil), forCellReuseIdentifier: "UserPostTableViewCell")
        
        updateView()
        getShadow(buyButton)
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        afterButtonPressedView()
        getShadow(buyButton)
        buyprocess = true
        let parameters : Parameters = [
            "user_id" : userDefaults.getUserDefaults("ID"),
            "mobile" : userDefaults.getUserDefaults("Mobile"),
            "process" : "buy"
        ]
        hitApi(parameters)
    }
    
    @IBAction func sellButtonPressed(_ sender: Any) {
        afterButtonPressedView()
        getShadow(sellButton)
        buyprocess = false
        let parameters : Parameters = [
            "user_id" : userDefaults.getUserDefaults("ID"),
            "mobile" : userDefaults.getUserDefaults("Mobile"),
            "process" : "sell"
        ]
        hitApi(parameters)
    }
    
    func hitApi(_ param : Parameters){
        
        Alamofire.request(URL_MY_POST, method: .get, parameters: param).responseJSON{ [self]
            response in
            
            if let result = response.data {
                let decoder = JSONDecoder()
                do {
                    userResult = try decoder.decode(PostData.self, from: result)
                    if userResult?.error == false{
                        
                        if userResult?.data_exist != 0{
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
    
    
    func updateView(){
        buyprocess = true
        tableView.isHidden = true
        noResultImage.layer.cornerRadius = noResultImage.bounds.height/2
        buyButton.layer.cornerRadius = 10
        sellButton.layer.cornerRadius = 10
        let parameters : Parameters = [
            "user_id" : userDefaults.getUserDefaults("ID"),
            "mobile" : userDefaults.getUserDefaults("Mobile"),
            "process" : "buy"
        ]
        hitApi(parameters)
    }
    
    func getShadow(_ uiButton : UIButton){
        uiButton.backgroundColor = UIColor.init(named: K.BrandColor.accentColor)
        uiButton.layer.shadowPath = UIBezierPath.init(rect: uiButton.bounds).cgPath
        uiButton.layer.shadowRadius = 10
        uiButton.layer.shadowOffset = .zero
        uiButton.layer.shadowOpacity = 1
    }
    
    func afterButtonPressedView(){
        sellButton.backgroundColor = UIColor.systemGray6
        buyButton.backgroundColor = UIColor.systemGray6
    }
}

//MARK: - tabelView datasource and delegate
extension MyPostViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userResult?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostTableViewCell") as! UserPostTableViewCell
        
        if userResult?.data_exist == 1{
            cell.commodityImage.image = UIImage.init(named: (userResult?.data[indexPath.row].commodity)!+".jpg")
            if userResult?.data[indexPath.row].variety != ""{
                cell.commodityName.text = userResult?.data[indexPath.row].variety
            }else{
                cell.commodityName.text = userResult?.data[indexPath.row].commodity
            }
            cell.commodityType.text = userResult?.data[indexPath.row].commodity_type
            cell.priceLabel.text = "₹"+(userResult?.data[indexPath.row].expected_price)!
            cell.postDate.text = userResult?.data[indexPath.row].post_date
            cell.quantityLabel.text = (userResult?.data[indexPath.row].quantity)!+"/"+(userResult?.data[indexPath.row].unit)!
            cell.userLocation.text = (userResult?.data[indexPath.row].state)!+" | "+(userResult?.data[indexPath.row].district)!+" | "+(userResult?.data[indexPath.row].taluka)!
            
            print(indexPath.section)
            cell.yourobj = { [self] in
                if buyprocess == true{
                    let parameters : Parameters = [
                        "id" : userResult?.data[indexPath.row].post_id ?? 0,
                        "process" : "buy"
                    ]
                    self.showAlertAction("Do you want to delete this post?",parameters,process: "buy")
                    
                }else{
                    let parameters : Parameters = [
                        "id" : userResult?.data[indexPath.row].post_id ?? 0,
                        "process" : "sell"
                    ]
                    self.showAlertAction("Do you want to delete this post?",parameters,process: "sell")
                }
            }
        }
        cell.selectionStyle = .none
        cell.viewUpdate()
        return cell
    }
    
    
    func showAlertAction(_ message:String ,_ param : Parameters,process:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
       
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler: { (UIAlertAction) in
            
            Alamofire.request(self.DELETE_URL, method: .post, parameters: param).responseJSON{ [self]
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let error = jsonData.value(forKey: "error") as! Int
                    if error == 0{
                        let parameters : Parameters = [
                            "user_id" : userDefaults.getUserDefaults("ID"),
                            "mobile" : userDefaults.getUserDefaults("Mobile"),
                            "process" : process
                        ]
                        hitApi(parameters)
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



