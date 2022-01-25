//
//  PostCreatedView.swift
//  Krishi
//
//  Created by Prashant Jangid on 09/06/21.
//

import UIKit

class PostCreatedView: UIView {

    
    @IBOutlet var view: UIView!
    @IBOutlet var createdView: UIView!
    
    @IBOutlet var goToHomeButton: UIButton!
    @IBOutlet var goToViewPost: UIButton!
   
    class func commonInit() -> PostCreatedView {
        let nibView = Bundle.main.loadNibNamed("PostCreatedView", owner: self, options: nil)?[0] as! PostCreatedView
        nibView.layoutIfNeeded()
        return nibView
    }
    
    override func draw(_ rect: CGRect) {
        view.layer.cornerRadius = 10
        viewUpdate(goToHomeButton)
        viewUpdate(goToViewPost)
    }
    
    func viewUpdate(_ btn : UIButton){
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
    }
    
    @IBAction func goToHomePressed(_ sender: UIButton) {
        AppDelegate.navBar.popToRootViewController(animated: true)
    }
    
    @IBAction func viewPostPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcFirst = storyboard.instantiateViewController(withIdentifier: "MyPostViewController") as! MyPostViewController
        
        AppDelegate.navBar.pushViewController(vcFirst, animated: true)
    }
}
