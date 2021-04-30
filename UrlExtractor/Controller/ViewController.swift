//
//  ViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            UIAlertController.showAlert("Reachable via wifi", self)
        case .cellular:
            UIAlertController.showAlert("Reachable via Cellular", self)
        case .unavailable:
            UIAlertController.showAlert("Network not reachable", self)
        }
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
