//
//  RateListViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 09/07/21.
//

import UIKit

class RateListViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    let ENDPOINT_API = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd00000143e218da3e65477c650a4661ce9e9d49&format=json&offset=0&limit=10000"
   
    var result : RatesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 180
        tableView.register(UINib(nibName: "CellMandiRatesTableViewCell", bundle: nil), forCellReuseIdentifier: "CellMandiRatesTableViewCell")
        indicator()
        performRequest(ENDPOINT_API)
    }
    
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)//2. create urlSession
            
            let task = session.dataTask(with: url) { (data, response, error) in
//                print(data)
                if error != nil {
                    print("error\(String(describing: error?.localizedDescription))")
                    return
                }
                if let data = data{
                    
                    do{
                        let decoder = JSONDecoder()
                        self.result = try decoder.decode(RatesModel.self, from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.indicatorStop()
                        }
                        return
                    }catch{
                        print("error\(error)")
                    }
                }
            }//3. give the session a tsk
            task.resume()  //4. start the taskv
        }
    }
    
    func indicator(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    func indicatorStop(){
        dismiss(animated: false, completion: nil)
    }
    
    
    
    
    @IBAction func FilterSearchButtonPressed(_ sender: UIButton) {
        draw()
    }
    
    func draw() {
        
        let viewDetail = ViewDetail.commonInit()
        
        viewDetail.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(viewDetail)
    }
    
    
}
extension RateListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMandiRatesTableViewCell") as! CellMandiRatesTableViewCell
        
        cell.dateLabel.text = result?.records[indexPath.row].arrival_date
        cell.commodityNameLabel.text = result?.records[indexPath.row].state
        cell.commodityQuantityLabel.text = result?.records[indexPath.row].commodity
        cell.commodityMinRateLabel.text = result?.records[indexPath.row].min_price
        cell.commodityMaxRateLabel.text = result?.records[indexPath.row].max_price
        cell.commodityModalRateLabel.text = result?.records[indexPath.row].modal_price
        
        cell.UIViewUpdate()
        return cell
    }
}
