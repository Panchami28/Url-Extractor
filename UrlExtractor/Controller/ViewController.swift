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
        self.navigationItem.title = "Home"
        // Do any additional setup after loading the view.
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let userUrlManagerViewController = storyboard.instantiateViewController(identifier: "UserUrlManagerViewController") as? UserUrlManagerViewController {
            self.navigationController?.pushViewController(userUrlManagerViewController, animated: true)
        }
    }
    
    @IBAction func viewSampleStationsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let mainChannelViewController = storyboard.instantiateViewController(identifier: "MainChannelViewController") as? MainChannelViewController {
            self.navigationController?.pushViewController(mainChannelViewController, animated: true)
        }
    }
    
    @IBAction func viewFavouritesButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let favouriteStreamViewController = storyboard.instantiateViewController(identifier: "FavouriteStreamViewController") as? FavouriteStreamViewController {
            self.navigationController?.pushViewController(favouriteStreamViewController, animated: true)
        }
    }
    
}
