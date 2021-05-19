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
    
    private var favoriteStreamDataManager = FavoriteStreamDataManager()
    private var recentStreamDataManager = StreamDataManager()
    private var basicChannelModel = BasicChannelModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTabBarController()
    }
    
//MARK: -
//MARK: Private Methods
//MARK: -
    func setupTabBarController() {
        ServiceManager.shared.addMiniController(self)
    }
    
    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainUrl = channelUrl
            streamUrlViewController.mainSiteName = channelName
        }
    }
    
    func playMusic(_ musicUrl:String,_ channelName: String) {
        PlayerManager.shared.playMusic(musicUrl,channelName)
        setupTabBarController()
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
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let stream = favoriteStreamDataManager.item(indexPath).url , let mainChannel = favoriteStreamDataManager.item(indexPath).mainChannel {
            recentStreamDataManager.addData(stream, mainChannel)
            playMusic(stream,mainChannel)
        }
    }
    
}

// MARK: -
// MARK: Custom Table cell Delegate
// MARK: -
extension FavouriteStreamViewController : StreamUrlCellDelegate {
    func moreButtonClicked(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Options", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Share", style: .default) { (action) in
            let items = [self.favoriteStreamDataManager.item(indexPath).url]
            let activityVC = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            self.presentActivityViewController(activityVC)
        }
        let action2 = UIAlertAction(title: "Go to station", style: .default) { (action) in
            let name = self.favoriteStreamDataManager.item(indexPath).mainChannel
            for i in 0..<self.basicChannelModel.numberOfChannels() {
                if name == "\(self.basicChannelModel.itemAtSpecificRow(atRow: i))" {
                    self.loadStreamUrlViewControllerData(self.basicChannelModel.itemAtSpecificRow(atRow: i).websiteUrl,name ?? "")
                    break
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancelAction)
        presentAlertController(alert)
    }
    
    func addToFavouritesButtonClicked(indexPath: IndexPath) {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "StreamUrlCell", for: indexPath) as! StreamUrlCell
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
