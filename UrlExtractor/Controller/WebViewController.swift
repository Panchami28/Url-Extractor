//
//  WebViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController ,WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var websiteUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "WebView"
        displayWebView()
    }
    
    func displayWebView() {
        if let requiredUrl = websiteUrl, let myURL = URL(string:requiredUrl) {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }

}
