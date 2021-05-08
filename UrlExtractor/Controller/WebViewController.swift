//
//  WebViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 30/04/21.
//

import UIKit
import SafariServices

class WebViewController: SFSafariViewController,SFSafariViewControllerDelegate {

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory()
    }
    
    public override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)
    }
    
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if  didLoadSuccessfully == true {
            loadingActivityIndicator.isHidden = true
        }
    }
}
