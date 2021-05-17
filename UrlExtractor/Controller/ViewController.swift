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
    let recentStreamDataMangaer = StreamDataManager()
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
            self.tabBarController?.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 120, width: self.view.frame.width, height: 70)
            self.tabBarController?.view.addSubview(vc.view)
            self.willMove(toParent: self.tabBarController)
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable wifi")
            //UIAlertController.showAlert("Reachable via wifi", self)
        case .cellular:
            UIAlertController.showAlert("Reachable via Cellular", self)
        case .unavailable:
            UIAlertController.showAlert("Network not reachable! UrlExtractor is offline", self)
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
        if let mainChannelCollectionViewController = storyboard.instantiateViewController(identifier: "MainChannelCollectionViewController") as? MainChannelCollectionViewController {
            self.navigationController?.pushViewController(mainChannelCollectionViewController, animated: true)
        }
    }
    
    @IBAction func viewFavouritesButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let favouriteStreamViewController = storyboard.instantiateViewController(identifier: "FavouriteStreamViewController") as? FavouriteStreamViewController {
            self.navigationController?.pushViewController(favouriteStreamViewController, animated: true)
        }
    }
    
    
    @IBAction func viewRecentButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let recentStreamTableViewController = storyboard.instantiateViewController(identifier: "RecentStreamTableViewController") as? RecentStreamTableViewController {
            self.navigationController?.pushViewController(recentStreamTableViewController, animated: true)
        }
    }
    
}
