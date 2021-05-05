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

class StreamUrlViewController: ViewController {
        
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

// MARK: -
// MARK: View LifeCycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        self.navigationItem.title = "Streaming Urls"
        //Register a custom cell
        urlTableView.register(UINib(nibName: "StreamUrlCell", bundle: nil), forCellReuseIdentifier: "StreamUrlCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //To load stream urls only once initially when view appears
        if self.isBeingPresented || self.isMovingToParent {
            if reachability.connection == .unavailable {
                loadingActivityIndicator.isHidden = true
            } else {
                scrapeWebpage(mainUrl) {
                    self.checkStreamUrlArray()
                }
            }
        }
    }
    

// MARK: -
// MARK: Private methods
// MARK: -
        
    func scrapeWebpage(_ mainUrl:String?,completion: @escaping ()-> Void) {
        scrapingWebpageQueue.async { [weak self] in
            do{
                guard let mainUrl = mainUrl, let requiredUrl = URL(string: mainUrl) else {
                    if let viewController = self {
                        UIAlertController.showAlert("Oops!Something went wrong", viewController)
                    }
                    return
                }
                let content = try String(contentsOf: requiredUrl)
                do{
                    //Get source code of entire webpage of given URL
                    let doc: Document = try SwiftSoup.parse(content)
                    let myText = try doc.outerHtml()
                    //Parse the source code for given regex
                    if let pattern = self?.regexx,
                       let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                        let string = myText as NSString
                        regex.matches(in: myText, options: [], range: NSRange(location: 0, length: string.length)).map { Result in
                            //If match found, get the corresponding URL
                            let obtainedString = string.substring(with: Result.range)
                            let obtainedUrl = URL(string: obtainedString)
                            //Check if corresponding URL is streamable or not
                            if let obtainedUrl = obtainedUrl {
                                self?.isPlayable(url: obtainedUrl) { (streamResult) in
                                    print(streamResult)
                                    //If URL is streamable, append it to streamUrlArray for further processing
                                    if streamResult == true {
                                        self?.streamUrlArray.append(obtainedString)
                                        self?.loadingActivityIndicator.isHidden = true
                                    }
                                    self?.urlTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error while parsing:\(error)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
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
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            let playerViewController = PlayerViewController()
            self.present(playerViewController, animated: true) {
                playerViewController.playMusic(requiredUrl)
                playerViewController.displayImage(self.mainSiteName)
            }
        } else {
            UIAlertController.showAlert("Unable to play the track", self)
        }
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
        var favUrlArray = [String]()
        let cell = urlTableView.dequeueReusableCell(withIdentifier: "StreamUrlCell", for: indexPath) as! StreamUrlCell
        cell.streamLabel.text = streamUrlArray[indexPath.row]
        cell.delegate = self
        cell.indexpath = indexPath
        //Check if streamUrl is present in favorite stream list to display heart
        favoriteStreamDataManager.getData()
        favUrlArray = favoriteStreamDataManager.getUrl(favUrlArray)
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
        playMusic(streamUrlArray[indexPath.row])
        //Check if network is available
        if reachability.connection == .cellular || reachability.connection == .wifi {
            streamDataManager.addData(streamUrlArray[indexPath.row],mainSiteName)
        }
    }
}

// MARK: -
// MARK: Custom Table cell Delegate
// MARK: -
extension StreamUrlViewController: StreamUrlCellDelegate {
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
