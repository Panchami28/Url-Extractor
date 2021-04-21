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
        if let userUrlManagerViewCon = storyboard.instantiateViewController(identifier: "UserUrlManagerViewCon") as? UserUrlManagerViewController {
            self.navigationController?.pushViewController(userUrlManagerViewCon, animated: true)
        }
    }

}
