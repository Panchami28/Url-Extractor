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
    var basicChannelModel = BasicChannelModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //recentTableView.separatorStyle = .none
        streamDataManager.getData()
        //Register a custome cell
        recentTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
        recentTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recentTableView.reloadData()
    }
// MARK: -
// MARK: - Private Methods
// MARK: -
    
    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainUrl = channelUrl
            streamUrlViewController.mainSiteName = channelName
        }
    }
    
    func playMusic(_ musicUrl:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
            self.tabBarController?.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 120, width: self.view.frame.width, height: 70)
            //vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.view.addSubview(vc.view)
            self.willMove(toParent: self.tabBarController)
            vc.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            vc.playMusic(musicUrl)
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
        cell.delegate = self
        cell.indexpath = indexPath
        if let channelImage = streamDataManager.item(indexPath).mainChannel {
        cell.channelImageView.image = UIImage(named: channelImage)
        } else {
            cell.channelImageView.image = UIImage(named: "RecentStation")
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let musicUrl = streamDataManager.item(indexPath).url, let channel = streamDataManager.item(indexPath).mainChannel{
            streamDataManager.addData(musicUrl,channel)
            streamDataManager.getData()
            recentTableView.reloadData()
            playMusic(musicUrl)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableHeight: CGFloat = recentTableView.bounds.size.height
        cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        var index = 0
        UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        index += 1
    }
}

extension RecentStreamTableViewController: StreamUrlCellDelegate {
    func addToFavouritesButtonClicked(indexPath: IndexPath) {
        print("Added to fav")
    }
    
    func moreButtonClicked(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Options", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Share", style: .default) { (action) in
            let items = [self.streamDataManager.item(indexPath).url]
            let activityVC = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            self.presentActivityViewController(activityVC)
        }
        let action2 = UIAlertAction(title: "Go to station", style: .default) { (action) in
            let name = self.streamDataManager.item(indexPath).mainChannel
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
}
