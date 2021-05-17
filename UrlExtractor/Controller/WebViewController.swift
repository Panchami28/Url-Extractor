//
//  WebViewViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 09/05/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var websiteString: String?
    private var basicChannelModel = BasicChannelModel()
    private var recentSearchManager = RecentSearchManager()

//MARK: -
//MARK: Instantiation
//MARK: -

//    class func instantiate(url: String?, siteName: String? = nil) -> WebViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        if let webViewController = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController {
//            webViewController.websiteUrl = url
//            return webViewController
//        }
//        //let webVC = UIStoryboard.Main.instantiateViewController(identifier: "WebViewController") as! WebViewController
//        //webVC.websiteUrl = url
//    }
    
//MARK: -
//MARK: Instantiation
//MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Extract Streams", style: .done, target: self, action: #selector(extractButtonTapped))
        displayWebView()
    }

    @objc func extractButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            if let currentUrl = webView.url {
                streamUrlViewController.mainUrl = "\(currentUrl)"
                streamUrlViewController.mainSiteName = "RecentStation"
                //print("CurrentUrl:\(currentUrl)")
                recentSearchManager.addData("\(currentUrl)")
            }
        }
    }
    
    func displayWebView() {
        if let requiredString = websiteString, let myUrl = URL(string: requiredString) {
            let request = URLRequest(url: myUrl)
            webView.load(request)
        }
    }

}

