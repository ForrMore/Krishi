//
//  PostCommodityViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit

class PostCommodityViewController: UIViewController {

 
    @IBOutlet var tableView: UITableView!
    var result: Result?
    var commodityString : String = ""
    var userCommodityArray = [String]()
    var userData = UserData()
    var processData = [String:String]()//to get and pass data
    var convertToArray = StringConverter()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseJSON()
        commodityString = userData.getUserDefaults("userCommodity") as! String
        userCommodityArray = convertToArray.stringToArray(commodityString)
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
extension PostCommodityViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView : UITableView) -> Int {
        return (result?.commodity.count)!+1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return "Your commodity" //-1
        }
        else{
            return result?.commodity[section-1].title //6
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return userCommodityArray.count
        }
        else if let result = result{
            return result.commodity[section-1].items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier : K.cellIdentifier,for : indexPath) as! CellCommodity
        
        if indexPath.section == 0 {
            let text = userCommodityArray[indexPath.row]
            
            cell.viewUpdate()
            cell.commodityName.text = text
            cell.hideCheckImageView()
            let imageName = text
            
            // set image to cell
            if UIImage.init(named: imageName+".jpg") != nil{
                cell.commodityImage.image = UIImage.init(named: imageName+".jpg")
            }else{
                cell.commodityImage.image = UIImage.init(named: "anyCommodity.jpg")
            }
        }
        else{
            let text = result?.commodity[indexPath.section-1].items[indexPath.row]
            
            cell.viewUpdate()
            cell.commodityName.text = text
            cell.hideCheckImageView()
            let imageName = text
            
            // set image to cell
            if UIImage.init(named: imageName!+".jpg") != nil{
                cell.commodityImage.image = UIImage.init(named: imageName!+".jpg")
            }else{
                cell.commodityImage.image = UIImage.init(named: "anyCommodity.jpg")
            }
        }
        return cell
    }
}

//MARK: - table view delegate method
extension PostCommodityViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            processData["commodity"] = userCommodityArray[indexPath.row]
            performSegue(withIdentifier: "goToPostDataViewController", sender: self)
        }else{
            processData["commodity"] = result?.commodity[indexPath.section-1].items[indexPath.row]
            performSegue(withIdentifier: "goToPostDataViewController", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostDataViewController
        destinationVC.processData = processData
    }
}
