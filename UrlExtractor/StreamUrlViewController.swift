//
//  DisplayViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit
import SwiftSoup
import AVFoundation
import AVKit

class StreamUrlViewController: ViewController {
        
    @IBOutlet weak var urlTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var mainUrl:String = ""
    var mainSiteName:String = ""
    var streamUrlArray = [String]()
    var regexx = "(https?://)[-a-zA-Z0-9@:%._\\+~#=;]{2,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+;.~#?&//=]*)"
    

// MARK: -
// MARK: View LifeCycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        self.navigationItem.title = "Streaming Urls"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.isBeingPresented || self.isMovingToParent {
            scrapeWebpage(mainUrl) {
                self.checkStreamUrlArray()
            }
        }
    }
    

// MARK: -
// MARK: Private methods
// MARK: -
        
    func scrapeWebpage(_ mainUrl:String?,completion: @escaping ()->()) {
        do{
            guard let mainUrl = mainUrl, let requiredUrl = URL(string: mainUrl) else { UIAlertController.showAlert("Oops!Something went wrong", self)
                return
            }
            let content = try String(contentsOf: requiredUrl)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let myText = try doc.outerHtml()
                if let regex = try? NSRegularExpression(pattern: regexx, options: .caseInsensitive) {
                    let string = myText as NSString
                    regex.matches(in: myText, options: [], range: NSRange(location: 0, length: string.length)).map { Result in
                        let obtainedString = string.substring(with: Result.range)
                        let obtainedUrl = URL(string: obtainedString)
                        if let obtainedUrl = obtainedUrl {
                            isPlayable(url: obtainedUrl) { (streamResult) in
                                print(streamResult)
                                if streamResult == true {
                                    self.streamUrlArray.append(obtainedString)
                                    self.loadingActivityIndicator.isHidden = true
                                }
                                self.urlTableView.reloadData()
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error while parsing:\(error)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
            completion()
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
    
    func playMusic(_ musicUrl:String)
    {
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            let player = AVPlayer(url: requiredUrl)
            // Creating a player view controller
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
                if let frame = playerViewController.contentOverlayView?.bounds {
                    let imageView = UIImageView(image: UIImage(named: self.mainSiteName))
                    imageView.frame = frame
                    playerViewController.contentOverlayView?.addSubview(imageView)
                }
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
        let cell = urlTableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        cell.textLabel?.text = streamUrlArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playMusic(streamUrlArray[indexPath.row])
    }
    
}

