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
        //Get data from database
        favoriteStreamDataManager.getData()
        if favoriteStreamDataManager.numberOfItems() == 0 {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove all", style: .plain, target: self, action:#selector(removeAll))
        }
        favoritesTableView.separatorStyle = .none
        //Register a custome cell
        favoritesTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
    }
    
//MARK: -
//MARK: Private Methods
//MARK: -
    
    func playMusic(_ musicUrl: String,_ mainSiteName: String) {
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            let playerViewController = PlayerViewController()
            self.present(playerViewController, animated: true) {
                playerViewController.playMusic(requiredUrl)
                playerViewController.displayImage(mainSiteName)
            }
        } else {
            UIAlertController.showAlert("Unable to play the track", self)
        }
    }
    
    @objc func removeAll() {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove all streams from list?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.favoriteStreamDataManager.deleteAllData()
            self.favoritesTableView.reloadData()
            self.navigationItem.rightBarButtonItem = nil
        }
        let action2 = UIAlertAction(title: "No", style: .default)
        alert.addAction(action1)
        alert.addAction(action2)
        presentAlertController(alert)
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
        cell.channelImageView.image = UIImage(named: favoriteStreamDataManager.item(indexPath).mainChannel ?? "")
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
        if let currentUrl = self.favoriteStreamDataManager.item(indexPath).url {
            let alert = UIAlertController(title: "Alert", message: "Do you want to remove \(currentUrl) from list?", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Remove", style: .destructive) { (action) in
                cell.favoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.favoriteStreamDataManager.deleteData(self.favoriteStreamDataManager.item(indexPath))
                self.favoritesTableView.deleteRows(at: [indexPath], with: .fade)
                self.favoritesTableView.reloadData()
            }
            let action2 = UIAlertAction(title: "Cancel", style: .default)
            alert.addAction(action1)
            alert.addAction(action2)
            presentAlertController(alert)
        }
        favoritesTableView.reloadData()
    }
}
