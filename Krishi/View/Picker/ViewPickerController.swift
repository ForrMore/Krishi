//
//  ViewPickerController.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import UIKit

class ViewPickerController: UIView {
    
    
    @IBOutlet var viewPicker: UIView!
    @IBOutlet var viewBg: UIView!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var picker: UIPickerView!
    
    typealias complitionHandler = (_ item:String,_ index:Int)->Void
    
    var array = [String]()
    var complition : complitionHandler?
    var imagePicker = UIImagePickerController()
    var tempImage : UIImage?
    
    
    class func commonInit() -> ViewPickerController {
        let nibView = Bundle.main.loadNibNamed("ViewPickerController", owner: self, options: nil)?[0] as! ViewPickerController
        nibView.layoutIfNeeded()
        return nibView
    }
    
    
    @IBAction func tapDone(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.viewBg.alpha = 0
            self.viewPicker.frame.origin.y = Instance.height
            self.removeFromSuperview()
        }
    }
    
    
    class func open(array:[String],complition:@escaping(_ item:String,_ index:Int)->Void) {
        
        if array.count > 0 {
            let picker = ViewPickerController.commonInit()
            picker.frame = Instance.frame
            DispatchQueue.main.async {
                picker.frame = Instance.frame
            }
            Instance.shared.addOnTopWindow(view: picker)
            picker.open(array: array) { (item,index)  in
                complition(item,index)
            }
        }else{
            print("array does have value")
        }
    }
    
    
    func open(array:[String],complition:@escaping(_ item:String,_ index:Int)->Void) {
        self.array = array
        self.complition = complition
        picker.delegate = self
        picker.dataSource = self
        
        viewPicker.frame = CGRect.init(x: 0, y: Instance.height, width: Instance.width, height: viewPicker.frame.height)
        
        viewBg.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.viewBg.alpha = 0.3
            self.viewPicker.frame = CGRect.init(x: 0, y: Instance.height - self.viewPicker.frame.height , width: Instance.width, height: self.viewPicker.frame.height)
            
        }
    }
}


//MARK:- input type and textfield delegates
extension  ViewPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        complition?(array[row], row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
