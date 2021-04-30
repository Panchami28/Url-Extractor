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
    }
    
    public override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if  didLoadSuccessfully == true {
            loadingActivityIndicator.isHidden = true
        }
    }
}
