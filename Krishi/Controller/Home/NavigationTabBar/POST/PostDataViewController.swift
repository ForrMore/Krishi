//
//  PostDataViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 29/05/21.
//

import UIKit

class PostDataViewController: UIViewController {

    var unitList : [String] = ["Unit","Kg","Dozen","Quintal","Tonnes"]
    
    var unitindex : Int = 0
    var optionString : String = "Organic"
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var fpoOption: UIButton!
    @IBOutlet var residueOption: UIButton!
    @IBOutlet var organicOption: UIButton!
    @IBOutlet var showUnitLabel: UILabel!
    @IBOutlet var unitCollectionView: UICollectionView!
    @IBOutlet var varietyTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expectedTextField: UITextField!
    var processData = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUnitLabel.layer.cornerRadius = showUnitLabel.bounds.height/2
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.textColor = UIColor.placeholderText
        buttonArrayUpdated()
        viewUpdate()
    }
    
    func viewUpdate(){
        varietyTextField.text = processData["commodity"]
    }
    
    @IBAction func organicButtonPressed(_ sender: UIButton) {
        optionString = "Organic"
        buttonArrayUpdated()
        organicOption.setImage(UIImage.init(systemName: "largecircle.fill.circle"), for: .normal)
    }
    @IBAction func residueButtonPressed(_ sender: UIButton) {
        optionString = "Residue Free"
        buttonArrayUpdated()
        residueOption.setImage(UIImage.init(systemName: "largecircle.fill.circle"), for: .normal)
    }
    @IBAction func fpoButtonPressed(_ sender: UIButton) {
        optionString = "FPO"
        buttonArrayUpdated()
        fpoOption.setImage(UIImage.init(systemName: "largecircle.fill.circle"), for: .normal)
    }
    
    func buttonArrayUpdated(){
        organicOption.setImage(UIImage.init(systemName: "circle.circle"), for: .normal)
        residueOption.setImage(UIImage.init(systemName: "circle.circle"), for: .normal)
        fpoOption.setImage(UIImage.init(systemName: "circle.circle"), for: .normal)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if quantityTextField.text == "" || expectedTextField.text == ""{
            showAlert("please fill required dat")
        }else{
            performSegue(withIdentifier: "goToShowPost", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        processData["inOption"] = optionString
        processData["productQuantity"] = quantityTextField.text
        processData["expectedPrice"] = expectedTextField.text
        processData["varity"] = varietyTextField.text
        processData["unitQuantity"] = showUnitLabel.text
        processData["productDescription"] = descriptionTextView.text
        
        let destinationVC = segue.destination as! ShowPostViewController
        destinationVC.processData = processData
        
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PostDataViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unitList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = unitCollectionView.dequeueReusableCell(withReuseIdentifier: "unitCollectionViewCell", for: indexPath) as! unitCollectionViewCell
        cell.updateView()
        cell.unitLabel.text = unitList[indexPath.row]
        if unitindex == indexPath.row{
            cell.unitLabel.backgroundColor = UIColor.init(named: K.BrandColor.lightGreen)
        }
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showUnitLabel.text = unitList[indexPath.row]
        unitindex = indexPath.row
        collectionView.reloadData()
    }
}

extension PostDataViewController : UITextViewDelegate,UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Product Description"{
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
            descriptionTextView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
