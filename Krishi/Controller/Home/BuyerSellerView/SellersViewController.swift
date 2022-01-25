//
//  SellersViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import UIKit
import Alamofire

class SellersViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noResultView: UIView!
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var noResultImage: UIImageView!
    
    
    var near : Bool = true
    var result : SellPostModel?
    let userDefaults = UserData()
    let stringConverter = StringConverter()
    let dateManger = DateTimeManager()
    let URL_SELLER_POST = K.ip+"krishi_app/v1/seller_post.php"
    var indexData : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        updateView()
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        
        self.near.toggle()
        
        if near == true{
            locationButton.image = UIImage.init(systemName: "location.circle.fill")
            let parameters : Parameters = [
                "state" : userDefaults.getUserDefaults("State"),
                "district" : userDefaults.getUserDefaults("District"),
                "taluka" : userDefaults.getUserDefaults("Taluka"),
                "process" : "near"
            ]
            hitApi(parameters)
        }else{
            locationButton.image = UIImage.init(systemName: "location.circle")
            let parameters : Parameters = [
                "state" : userDefaults.getUserDefaults("State"),
                "district" : userDefaults.getUserDefaults("District"),
                "taluka" : userDefaults.getUserDefaults("Taluka"),
                "process" : "all"
            ]
            hitApi(parameters)
        }
    }
    
    func hitApi(_ param : Parameters){
        
        Alamofire.request(URL_SELLER_POST, method: .get, parameters: param).responseJSON{ [self]
            response in
            
            print(response)
            
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    result = try decoder.decode(SellPostModel.self, from: data)
                    print(result!)
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
    
    func updateView(){
        tableView.isHidden = true
        noResultImage.layer.cornerRadius = noResultImage.bounds.height/2
        
        let parameters : Parameters = [
            "state" : userDefaults.getUserDefaults("State"),
            "district" : userDefaults.getUserDefaults("District"),
            "taluka" : userDefaults.getUserDefaults("Taluka"),
            "process" : "near"
        ]
        hitApi(parameters)
    }
}


//MARK: - tableView dataSource
extension SellersViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        
        let postDate = result?.data[indexPath.row].post_date
        let date = stringConverter.convertDateToDate(postDate)
        let currentDate = stringConverter.convertDateToDate(dateManger.currentDate)
        
        if result?.data_exist == 1{
            
            
            if result?.data[indexPath.row].variety != ""{
                cell.commodityName.text = result?.data[indexPath.row].variety
            }else{
                cell.commodityName.text = result?.data[indexPath.row].commodity
            }
            cell.commodityType.text = result?.data[indexPath.row].commodity_type
            cell.priceLabel.text = "₹"+(result?.data[indexPath.row].expected_price)!
            
            cell.postDate.text = postDate
            cell.quantityLabel.text = (result?.data[indexPath.row].quantity)!+"/"+(result?.data[indexPath.row].unit)!
            cell.userLocation.text = (result?.data[indexPath.row].state)!+" | "+(result?.data[indexPath.row].district)!+" | "+(result?.data[indexPath.row].taluka)!
            cell.merchantName.text = result?.data[indexPath.row].username
            cell.merchantType.text = "Seller"
            cell.merchantType.backgroundColor = UIColor.systemYellow
            cell.merchantType.textColor = UIColor.darkGray
            
            
            if result?.data[indexPath.row].commodity_image_link == "null" || result?.data[indexPath.row].commodity_image_link == nil {
                cell.commodityImage.image = UIImage.init(named: (result?.data[indexPath.row].commodity)!+".jpg")
            }else{
                
                let urlString = result?.data[indexPath.row].commodity_image_link
                let url = URL(string: urlString!)
                
                let task =  URLSession.shared.dataTask(with: url!) { (data,_, error) in
                    guard let data = data, error == nil else{
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.commodityImage.image = image
                    }
                }
                task.resume()
            }
            
            if Int(date[0]) == Int(currentDate[0]) && Int(date[1]) == Int(currentDate[1]){
                if Int(currentDate[2])!-Int(date[2])! < 7{
                    cell.newLabel.isHidden = false
                }else{
                    cell.newLabel.isHidden = true
                }
            }else{
                cell.newLabel.isHidden = true
            }
            
        }
        cell.viewUpdate()
        
        
        return cell
    }
}

//MARK: - table view delegate
extension SellersViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SellPostHelper.shared.merchantData  = result?.data[indexPath.row]
        performSegue(withIdentifier: "goToShowMerchantPost", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MerchantPostViewController
        destinationVC.merchant_type = "seller"
    }
}
