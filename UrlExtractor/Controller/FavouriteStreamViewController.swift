//
//  FavouriteStreamViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import UIKit
import AVKit
import AVFoundation

class FavouriteStreamViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteStreamDataManager = FavoriteStreamDataManager()
    
// MARK: -
// MARK: View LifeCycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoriteStreamDataManager.getData()
        favoritesTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
    }
    
//MARK: -
//MARK: Private Methods
//MARK: -
    
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
    
}

//MARK: -
//MARK: TableView DataSorce and Delegate
//MARK: -

extension FavouriteStreamViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteStreamDataManager.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "StreamUrlCell", for: indexPath) as! StreamUrlCell
        cell.streamLabel.text = favoriteStreamDataManager.item(indexPath).url
        cell.favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.delegate = self
        cell.indexpath = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let stream = favoriteStreamDataManager.item(indexPath).url , let mainChannel = favoriteStreamDataManager.item(indexPath).mainChannel {
            playMusic(stream, mainChannel)
        }
    }
    
}

// MARK: -
// MARK: Custom Table cell Delegate
// MARK: -
extension FavouriteStreamViewController : StreamUrlCellDelegate {
    func addToFavouritesButtonClicked(indexPath: IndexPath) {
        let cell = favoritesTableView.cellForRow(at: indexPath) as! StreamUrlCell
        cell.favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteStreamDataManager.deleteData(favoriteStreamDataManager.item(indexPath))
        favoritesTableView.deleteRows(at: [indexPath], with: .fade)
        favoritesTableView.reloadData()
    }
}
