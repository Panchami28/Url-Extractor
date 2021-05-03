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
        streamDataManager.getData()
    }
// MARK: -
// MARK: - Private Methods
// MARK: -
    func playMusic(_ musicUrl: String,_ mainChannel: String) {
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            let player = AVPlayer(url: requiredUrl)
            // Creating a player view controller
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
                if let frame = playerViewController.contentOverlayView?.bounds {
                    let imageView = UIImageView(image: UIImage(named: mainChannel))
                    imageView.frame = frame
                    playerViewController.contentOverlayView?.addSubview(imageView)
                }
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
        let cell = recentTableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = streamDataManager.item(indexPath).url
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playMusic(streamDataManager.item(indexPath).url ?? "", streamDataManager.item(indexPath).mainChannel ?? "")
    }
}
