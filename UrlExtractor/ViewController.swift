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
        if let mainUrlViewController = storyboard.instantiateViewController(identifier: "MainUrlViewController") as? MainChannelViewController {
            self.navigationController?.pushViewController(mainUrlViewController, animated: true)
        }
    }

}
