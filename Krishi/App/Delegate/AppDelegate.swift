//
//  AppDelegate.swift
//  Krishi
//
//  Created by Prashant Jangid on 30/04/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread .sleep(forTimeInterval: 2);
        FirebaseApp.configure()
        let db = Firestore.firestore()
        print(db)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    // MARK: - Core Data stack


    class func launchWindow(window:UIWindow) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        
        if UserDefaults.standard.value(forKey: "ID") != nil{
            let vcFirst = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            AppDelegate.navBar = UINavigationController.init(rootViewController: vcFirst)
            window.rootViewController = AppDelegate.navBar
            window.makeKeyAndVisible()
            return
        }
        let vcFirst = storyboard.instantiateViewController(withIdentifier: "MobileNumberVC") as! VCLogin
    
        AppDelegate.navBar = UINavigationController.init(rootViewController: vcFirst)
//        let navigationController = UINavigationController.init(rootViewController: vcFirst)
        window.rootViewController = AppDelegate.navBar
        window.makeKeyAndVisible()
    }
    static var navBar = UINavigationController()
}

