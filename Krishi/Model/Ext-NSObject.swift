//
//  Ext-NSObject.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation
import UIKit
import AVFoundation

extension NSObject{
    func addOnTopWindow(view:UIView){
        let window = UIApplication.shared.keyWindow!
        window.addSubview(view)
    }
    
    func showAlert(title:String ,message: String?) {

        if (message == nil || message == "" ) {
            return
        }

        let view = UIApplication.topViewController()
        let errorMessage = message ?? "MESSAGE"
        let errorController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view?.present(errorController, animated: true, completion: nil)
    }
    
    func showAlertYesNO(title:String ,message: String?, comlition:@escaping(_ flag:Bool)->Void) {

    
        let view = UIApplication.topViewController()
        let errorMessage = message ?? "MESSAGE"
        let errorController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
            comlition(false)
        }))
        errorController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            comlition(true)
        }))
        view?.present(errorController, animated: true, completion: nil)
    }
    
    func showAlertCustom(title:String ,message: String?, btnTitle1:String, btnTitle2:String, comlition:@escaping(_ flag:Bool)->Void) {

    
        let view = UIApplication.topViewController()
        let errorMessage = message ?? "MESSAGE"
        let errorController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: btnTitle1, style: .destructive, handler: { _ in
            comlition(false)
        }))
        errorController.addAction(UIAlertAction(title: btnTitle2, style: .default, handler: { _ in
            comlition(true)
        }))
        view?.present(errorController, animated: true, completion: nil)
    }
}


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}

