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
    var regexx = "(https?://)[-a-zA-Z0-9@:%._\\+~#=;]{2,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+;.~#?&//=]*)"
    private var favoriteStreamDataManager = FavoriteStreamDataManager()
    private var streamDataManager = StreamDataManager()
    private lazy var scrapingWebpageQueue = DispatchQueue(label: "ScrapeWebpageQueue")
    private lazy var checkingStreamQueue = DispatchQueue(label: "StreamCheckingQueue")
    let viewController = ViewController()
    
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
        //scrapingWebpageQueue.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        urlTableView.reloadData()
        //To load stream urls only once initially when view appears
        if self.isBeingPresented || self.isMovingToParent {
            if viewController.reachability.connection == .unavailable {
                loadingActivityIndicator.isHidden = true
            } else {
                scrapeWebpage(mainUrl) {
                    self.checkStreamUrlArray()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    
// MARK: -
// MARK: Private methods
// MARK: -
        
    func scrapeWebpage(_ mainUrl:String?,completion: @escaping ()-> Void) {
        scrapingWebpageQueue.async { [weak self] in
            ///To ensure that completion block is fired only after all urls are fetched
            let myGroup = DispatchGroup()
            guard let mainUrl = mainUrl, let requiredUrl = URL(string: mainUrl) else {
                self?.handleError()
                return
            }
            do{
                ///Get source code of entire webpage of given URL
                let content = try String(contentsOf: requiredUrl)
                ///Parse the source code for given regex
                if let pattern = self?.regexx,
                   let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                    let string = (content) as NSString
                    regex.matches(in: content, options: [], range: NSRange(location: 0, length: string.length)).map {
                        ///To indicate that a batch inside the group has started execution
                        myGroup.enter()
                        ///If match found, get the corresponding URL
                        let obtainedString = string.substring(with: $0.range)
                        let obtainedUrl = URL(string: obtainedString)
                        ///Check if corresponding URL is streamable or not
                        if let obtainedUrl = obtainedUrl {
                            self?.isPlayable(url: obtainedUrl) { (streamResult) in
                                print(streamResult)
                                ///If URL is streamable, append it to streamUrlArray for further processing
                                if streamResult == true {
                                    self?.streamUrlArray.append(obtainedString)
                                    self?.loadingActivityIndicator.isHidden = true
                                }
                                self?.urlTableView.reloadData()
                                ///To indicate that a batch inside the group that had started executing has now finished its execution
                                ///This should be called inside the completion handler only
                               myGroup.leave()
                            }
                        }
                    }
                }
            } catch {
                self?.handleError()
                print("Error while parsing:\(error)")
            }
            ///Notify the main thread when all members inside the group have finished their execution
            myGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    func isPlayable(url: URL, completion: @escaping (Bool) -> ()) {
        let asset = AVAsset(url: url)
        let playableKey = "playable"
        asset.loadValuesAsynchronously(forKeys: [playableKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            //Check the status of asset passed and store the result in isPlayable
            let isPlayable = status == .loaded
            DispatchQueue.main.async {
                completion(isPlayable)
            }
        }
    }
    
    func checkStreamUrlArray() {
        if streamUrlArray.isEmpty {
            loadingActivityIndicator.isHidden = true
            UIAlertController.showAlert("\(mainUrl) doesn't have any streaming urls that can be fetched", self)
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
    
    func createTabBarController(_ vc: PlayerViewController) {
        tabBarController?.addChild(vc)
        vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 150, width: self.view.frame.width, height: 100)
        vc.modalTransitionStyle = .crossDissolve
        tabBarController?.view.addSubview(vc.view)
        vc.willMove(toParent: tabBarController)
    }
    
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
            cell.favoritesButton.setImage(UIImage(systemName:"heart"), for: .normal)
        }
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
