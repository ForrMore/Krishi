//
//  ChangeCommodityUIViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit
import Alamofire

class ChangeCommodityUIViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var result: Result?
    var arrCommodity = [String:SelectedCommodity]()
    var userSelectedCommodity = [String]()
    var createdUser : NSDictionary?
    var userId_userMobile : [Int]?
    var URL_UPDATE_COMMODITY = K.Url.updateCommodity
    var commodityStirng : String = ""
    
    var userData = UserData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseJSON()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        for (key,value) in arrCommodity{
            if arrCommodity[key]?.isSelected == true{
                commodityStirng = commodityStirng+"_\(value.name)"
            }
        }
        
        let parameters :Parameters = [
            "user_id" : userData.getUserDefaults("ID"),
            "mobile": userData.getUserDefaults("Mobile"),
            "user_commodity":commodityStirng
        ]

        //Sending http post request
        Alamofire.request(URL_UPDATE_COMMODITY, method: .post, parameters: parameters).responseJSON{ [self]
            response in

            print(response)

            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                print(jsonData,"-------")

                let error = jsonData.value(forKey: "error") as! Int
                if error == 0{
                    
                    
                    //set data to defaults
                    self.userData.setDefaults(key: "userCommodity", data: self.commodityStirng)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePrfileData"), object: nil, userInfo: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let message = "error"
                    self.showAlert(message)
                }
            }
        }
        
    }
 
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
    
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // parse json into and its stuct named (result)
    private func parseJSON(){
        guard let path = Bundle.main.path(forResource: K.jsonFileName[0], ofType: K.jsonFileName[1])else {return}
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self,from: jsonData)
        }catch{
            print("here is an error \(error)")
        }
    }
}

//MARK: - table view  data source Method
extension ChangeCommodityUIViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView : UITableView) -> Int {
        return result?.commodity.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return result?.commodity[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result{
            return result.commodity[section].items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = result?.commodity[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier : K.cellIdentifier,for : indexPath) as! CellCommodity
        
        cell.viewUpdate()
        cell.commodityName.text = text
        let imageName = text ?? "anyCommodity"
        
        // set image to cell
        if UIImage.init(named: imageName+".jpg") != nil{
            cell.commodityImage.image = UIImage.init(named: imageName+".jpg")
        }else{
            cell.commodityImage.image = UIImage.init(named: "anyCommodity.jpg")
        }
        
        // check if seleted or not cell
        if arrCommodity[text!]?.isSelected == true{
            cell.checkImage.image = UIImage.init(systemName: "checkmark.circle.fill")
        }
        else{
            cell.checkImage.image = UIImage.init(systemName: "circle")
        }
        
        return cell
    }
}

//MARK: - table view delegate method
extension ChangeCommodityUIViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = result?.commodity[indexPath.section].items[indexPath.row]{
            if arrCommodity[item] != nil{
                arrCommodity[item]?.isSelected.toggle()
            }else{
                let commo = SelectedCommodity(name: item, isSelected: true)
                arrCommodity[item] = commo
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

