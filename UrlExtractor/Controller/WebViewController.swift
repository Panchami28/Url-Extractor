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
    var websiteUrl: String?
    private var basicChannelModel = BasicChannelModel()
    private var recentSearchManager = RecentSearchManager()
    
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
        if let requiredUrl = websiteUrl, let myUrl = URL(string: requiredUrl) {
            let request = URLRequest(url: myUrl)
            webView.load(request)
        }
    }

}

