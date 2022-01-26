//
//  SelectCommodityVC.swift
//  Krishi
//
//  Created by Prashant Jangid on 23/05/21.
//

import UIKit
import Alamofire

class VCCommodity: UIViewController {
    
    //TODO: - here i have to set user defaults of NSDictionary
    //MARK: - Variable
    @IBOutlet weak var tableView: UITableView!
    var result: Result?
    var arrCommodity = [String:SelectedCommodity]()
    var userSelectedCommodity = [String]()
    var createdUser : NSDictionary?
    var userId_userMobile : [Int]?
    var URL_UPDATE_COMMODITY = K.Url.updateCommodity
    var commodityStirng : String = ""
    
    var userData = UserData()
    
    // life cycle of view controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        for (key,value) in arrCommodity{
            if arrCommodity[key]?.isSelected == true{
                commodityStirng = commodityStirng+"_\(value.name)"
                print(commodityStirng)
            }
        }
        print(userId_userMobile![0],userId_userMobile![1])
        let parameters :Parameters = [
            "user_id" : userId_userMobile![0],
            "mobile": String(userId_userMobile![1]),
            "user_commodity": String(commodityStirng)
        ]

        //Sending http post request
        Alamofire.request(URL_UPDATE_COMMODITY, method: .post, parameters: parameters).responseJSON{
            response in

            print(response)

            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                print(jsonData,"-------")

                let error = jsonData.value(forKey: "error") as! Int
                if error == 0{
                    self.createdUser =  self.convertStringToDictionary(text: jsonData.value(forKey: "data") as! String) as NSDictionary?
                    
                    //set data to defaults
                    self.userData.setUserDefaults(self.createdUser!)
                    
                    self.performSegue(withIdentifier: K.GoTo.homeScreenVC, sender: self)
                }else{
                    let message = "error"
                    self.showAlert(message)
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
    
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // parse json into and its stuct named (result)
    private func parseJSON(){
        do {
            result = try JSONParser.JsonParser(fileName: K.jsonFileName[0], toModel: Result.self)
        }catch{
            print(error)
        }
//        guard let path = Bundle.main.path(forResource: K.jsonFileName[0], ofType: K.jsonFileName[1])else {return}
//        let url = URL(fileURLWithPath: path)
//        do{
//            let jsonData = try Data(contentsOf: url)
//            result = try JSONDecoder().decode(Result.self,from: jsonData)
//        }catch{
//            print("here is an error \(error)")
//        }
    }
}

//MARK: - table view  data source Method
extension VCCommodity : UITableViewDataSource{
    
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
extension VCCommodity : UITableViewDelegate{
    
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
