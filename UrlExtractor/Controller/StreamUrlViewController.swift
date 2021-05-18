//
//  StreamUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit
import SwiftSoup
import AVFoundation
import AVKit
import Reachability

class StreamUrlViewController: UIViewController {
        
    @IBOutlet weak var urlTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
// MARK: -
// MARK: variable declarations
// MARK: -
    var mainUrl:String = ""
    var mainSiteName:String = ""
    var streamUrlArray = [String]()
    private var favoriteStreamDataManager = FavoriteStreamDataManager()
    private var streamDataManager = StreamDataManager()
    let viewController = ViewController()
    let websiteStreamURLExtractor = WebsiteStreamURLExtractor()
    
// MARK: -
// MARK: View LifeCycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        //To add navigation title for the page
        self.navigationItem.title = "Streaming Urls"
        //To add navigation button for the page
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,target: self, action: #selector(shareStreams))
        //To get rid of lines in table view
        urlTableView.separatorStyle = .none
        //Register a custom cell
        urlTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        urlTableView.reloadData()
        //To load stream urls only once initially when view appears
        if self.isBeingPresented || self.isMovingToParent {
            if viewController.reachability.connection == .unavailable {
                loadingActivityIndicator.isHidden = true
            } else {
                callScrapeWebpage()
            }
        }
    }
    
    
    
// MARK: -
// MARK: Private methods
// MARK: -

    func callScrapeWebpage() {
        websiteStreamURLExtractor.scrapeWebpage(mainUrl) { (streamableUrl) in
            self.loadingActivityIndicator.isHidden = true
            if streamableUrl.isEmpty {
                UIAlertController.showAlert("\(self.mainUrl) has no streaming URLs that can be extracted", self)
            } else if streamableUrl == "error" {
                self.handleError()
            } else {
                self.streamUrlArray.append(streamableUrl)
                self.urlTableView.reloadData()
            }
        }
    }
    
    func playMusic(_ musicUrl:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
            self.tabBarController?.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 120, width: self.view.frame.width, height: 70)
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.view.addSubview(vc.view)
            self.willMove(toParent: self.tabBarController)
            vc.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            MiniPlayerViewController.isPlaying = true
            vc.playMusic(musicUrl)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleError() {
        DispatchQueue.main.async {
            self.loadingActivityIndicator.isHidden = true
            UIAlertController.showAlert("Oops!Something has gone wrong", self)
        }
    }
    
    @objc func shareStreams() {
        let fileName = "TempUrlFile"
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        // prints the file path
        print("File path \(fileUrl.path)")
        //data to write in file
        var fileData: String = ""
        for i in 0..<streamUrlArray.count {
            fileData.append(streamUrlArray[i])
            fileData.append("\n")
        }
        do {
            try fileData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
            let data = try String(contentsOfFile: fileUrl.path, encoding: String.Encoding.utf8)
            presentShareSheet(data)
        } catch let error as NSError {
            UIAlertController.showAlert("Error:\(error)", self)
        }
    }
    
    func presentShareSheet(_ data: String) {
        let items = [data]
        if data.isEmpty {
            UIAlertController.showAlert("No data to share", self)
        } else {
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                //ac.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
                present(ac, animated: true, completion: nil)
            } else {
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
//    func createTabBarController(_ vc: PlayerViewController) {
//        tabBarController?.addChild(vc)
//        vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 150, width: self.view.frame.width, height: 100)
//        vc.modalTransitionStyle = .crossDissolve
//        tabBarController?.view.addSubview(vc.view)
//        vc.willMove(toParent: tabBarController)
//    }
    
}
// MARK: -
// MARK: Tableview DataSource and Delegates
// MARK: -

extension StreamUrlViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamUrlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = urlTableView.dequeueReusableCell(withIdentifier: "StreamUrlCell", for: indexPath) as! StreamUrlCell
        cell.streamLabel.text = streamUrlArray[indexPath.row]
        cell.channelImageView.image = UIImage(named: mainSiteName)
        cell.delegate = self
        cell.indexpath = indexPath
        //Check if streamUrl is present in favorite stream list to display heart
        let favUrlArray = favoriteStreamDataManager.getUrl()
        if favUrlArray.contains(streamUrlArray[indexPath.row]) {
            let item = favoriteStreamDataManager.getSelectedData(streamUrlArray[indexPath.row])
            if item.heartName == "filled" {
                cell.favoritesButton.setImage(UIImage(systemName:"heart.fill"), for: .normal)
            }
        } else {
            //cell.favoritesButton.isHidden = true
            cell.favoritesButton.setImage(UIImage(systemName:"heart"), for: .normal)
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check if network is available
        if viewController.reachability.connection == .cellular || viewController.reachability.connection == .wifi {
            streamDataManager.addData(streamUrlArray[indexPath.row],mainSiteName)
            playMusic(streamUrlArray[indexPath.row])
        }
    }
}

// MARK: -
// MARK: Custom Table cell Delegate
// MARK: -
extension StreamUrlViewController: StreamUrlCellDelegate {
    func moreButtonClicked(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Options", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Share", style: .default) { (action) in
            let items = [self.streamUrlArray[indexPath.row]]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.presentActivityViewController(activityVC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action1)
        alert.addAction(cancelAction)
        presentAlertController(alert)
    }
    
    func addToFavouritesButtonClicked(indexPath: IndexPath) {
        let result = favoriteStreamDataManager.addData(streamUrlArray[indexPath.row], mainSiteName)
        //If stream URL is already prsent in favourite list, then display action sheet with option to remove it from list
        if result == false {
            let alert = UIAlertController(title: "Alert", message: "\(streamUrlArray[indexPath.row]) already exists in Favorite list. Do you want to remove it from list?", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Remove", style: .default) { (action) in
                self.favoriteStreamDataManager.deleteSelectedData(self.streamUrlArray[indexPath.row])
                self.urlTableView.reloadData()
            }
            let action2 = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(action1)
            alert.addAction(action2)
            presentAlertController(alert)
        }
        urlTableView.reloadData()
    }
    
}
