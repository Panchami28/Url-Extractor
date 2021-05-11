//
//  RecentStreamTableViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 02/05/21.
//

import UIKit
import AVKit

class RecentStreamTableViewController: UITableViewController {
    @IBOutlet var recentTableView: UITableView!
    
    var streamDataManager = StreamDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        //recentTableView.separatorStyle = .none
        streamDataManager.getData()
        //Register a custome cell
        recentTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
    }
// MARK: -
// MARK: - Private Methods
// MARK: -
    func playMusic(_ musicUrl: String,_ mainChannel: String) {
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            // Creating an instance of playerViewController
            let playerViewController = PlayerViewController()
            self.present(playerViewController, animated: true) {
                playerViewController.playMusic(requiredUrl)
                playerViewController.displayImage(mainChannel)
            }
        } else {
            UIAlertController.showAlert("Unable to play the track", self)
        }
    }
    

// MARK: -
// MARK: - Table view data source
// MARK: -

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        streamDataManager.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentTableView.dequeueReusableCell(withIdentifier: "StreamUrlCell", for: indexPath) as! StreamUrlCell
        cell.streamLabel.text = streamDataManager.item(indexPath).url
        cell.favoritesButton.isHidden = true
        if let channelImage = streamDataManager.item(indexPath).mainChannel {
        cell.channelImageView.image = UIImage(named: channelImage)
        } else {
            cell.channelImageView.image = UIImage(named: "RecentStation")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playMusic(streamDataManager.item(indexPath).url ?? "", streamDataManager.item(indexPath).mainChannel ?? "")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableHeight: CGFloat = recentTableView.bounds.size.height
        cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        var index = 0
        UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0);
        }, completion: nil)
        index += 1
    }
}
