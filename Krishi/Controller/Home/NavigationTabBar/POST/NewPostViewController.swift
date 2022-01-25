//
//  NewPostViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 10/05/21.
//

import UIKit

class NewPostViewController: UIViewController {
    
    var processData = [String:String]()
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var buyView: UIView!
    @IBOutlet var celllabel: UILabel!
    @IBOutlet var buylabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        celllabel.layer.cornerRadius = celllabel.bounds.height/2
        buylabel.layer.cornerRadius = buylabel.bounds.height/2
        cellView.layer.cornerRadius = 10
        buyView.layer.cornerRadius = 10
    
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        processData["process"] = buylabel.text!
        performSegue(withIdentifier: "goToPostCommodity", sender: self)
    }
    @IBAction func sellButtonPressed(_ sender: Any) {
        processData["process"] = celllabel.text!
        performSegue(withIdentifier: "goToPostCommodity", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! PostCommodityViewController
        destinationVC.processData = processData
        
    }
}
