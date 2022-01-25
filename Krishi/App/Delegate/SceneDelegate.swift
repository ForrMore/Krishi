//
//  SceneDelegate.swift
//  Krishi
//
//  Created by Prashant Jangid on 30/04/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            AppDelegate.launchWindow(window: window)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

