//
//  HomeScreenViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit
import Reachability

class HomeScreenViewController: UIViewController {
    
//MARK: -
//MARK: Variable declarations
//MARK: -
    
    let reachability = try! Reachability()
    let recentStreamDataMangaer = StreamDataManager()

//MARK: -
//MARK: View Lifecycle
//MARK: -
    
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
       //setupTabBarController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupTabBarController()
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

//MARK: -
//MARK: IB Actions
//MARK: -
    
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

//MARK: -
//MARK: Private functions
//MARK: -
    func setupTabBarController() {
        ServiceManager.shared.addMiniController(self)
    }
    
}
