//
//  AgricultureNewsViewController.swift
//  Krishi
//
//  Created by Prashant Jangid on 05/06/21.
//

import UIKit
import WebKit

class AgricultureNewsViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        let myURL = URL(string:"https://www.indiaagronet.com/Government-Agriculture-Schemes/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        // Do any additional setup after loading the view.
    }
}

