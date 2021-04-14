//
//  ViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let displayViewController = storyboard.instantiateViewController(identifier: "DisplayViewController") as? DisplayViewController {
            self.navigationController?.pushViewController(displayViewController, animated: true)
        }
    }

}