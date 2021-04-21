//
//  DisplayViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 06/04/21.
//

import UIKit
import WebKit
import Alamofire
import Kanna
import SwiftSoup
import AVFoundation
import AVKit

class StreamUrlViewController: ViewController {
        
    @IBOutlet weak var urlTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var mainUrl:String = ""
    var mainSiteName:String = ""
    var streamUrlArray = [String]()
    var patternList = ["\"radio_station_stream_url\":\"https[^\"]*","\"streams\":\\[\\{\"url\":\"[^\"]*","https://media[^\"]*","http://stream[^\"]*","\"streamURL\":\"https[^\"]*","\"stream\":\"http[^\"]*","http(.*)stream\\.mp3","http(.*)listen\\.mp3","http(.*)awaz\\.mp3","http(.*)listen\\.mp3"]

// MARK: -
// MARK: View LifeCycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        callRequiredScrape(mainSiteName)
        loadingActivityIndicator.isHidden = true
        self.urlTableView.reloadData()
    }
// MARK: -
// MARK: Private methods
// MARK: -
    
    func callRequiredScrape(_ mainSiteName:String)
    {
        switch mainSiteName {
        case "RadioNet": streamUrlArray = []
           mainUrl = "https://www.radio.net/"
        case "ShalomBeats Radio": streamUrlArray = []
            mainUrl = "http://shalombeatsradio.com/"
        case "NammRadio": streamUrlArray = []
            mainUrl = "http://nammradio.com/"
        case "RadioMirchi": streamUrlArray = []
            mainUrl = "https://www.radiomirchi.com/"
        case "RetroFM": streamUrlArray = []
            mainUrl = "https://sky.ee/tag/retrofm/"
        case "CBCListen": streamUrlArray = []
            mainUrl = "https://www.cbc.ca/listen/live-radio"
        case "HindiRadio": streamUrlArray = []
            mainUrl = "https://hindiradios.com/"
        case "Indian Australian Radio": streamUrlArray = []
            mainUrl = "https://hindiradios.com/australian-indian-radio"
        case "Bombay Beats": streamUrlArray = []
            mainUrl = "https://hindiradios.com/bombay-beats-radio"
        case "RadioCity Hindi": streamUrlArray = []
            mainUrl = "https://hindiradios.com/radio-city-hindi-fm"
        default: mainUrl = mainUrl+""
        }
        scrapeWebpage(mainUrl)
        checkStreamUrlArray()
    }
    
    func scrapeWebpage(_ mainUrl:String?) {
        do{
            guard let mainUrl = mainUrl, let requiredUrl = URL(string: mainUrl) else { UIAlertController.showAlert("Oops!Something went wrong", self)
                return
            }
            let content = try String(contentsOf: requiredUrl)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let myText = doc.data()
                //print(myText)
                for pattern in patternList {
                    let p = Pattern.compile(pattern)
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if let streamUrl = json {
                            //print("\(streamUrl)\n\n\n")
                            let newStreamUrl = streamUrl.replacingOccurrences(of: "\\", with: "")
                            if let regex = try? NSRegularExpression(pattern: "http[^\"]*", options: .caseInsensitive) {
                                let string = newStreamUrl as NSString
                                regex.matches(in: newStreamUrl, options: [], range: NSRange(location: 0, length: string.length)).map {Result in
                                    streamUrlArray.append(string.substring(with: Result.range))
                                }
                            }
                        }
                    }
                }
                if streamUrlArray.isEmpty {
                    let requiredCode = try doc.getElementsByClass("cc_streaminfo")
                    for element:Element in requiredCode {
                        let tag = try element.attr("href")
                        streamUrlArray.append(tag)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func checkStreamUrlArray() {
        if streamUrlArray.isEmpty {
            UIAlertController.showAlert("\(mainUrl) doesn't have streamable URLs that can be extracted", self)
        }
    }
    
    func playMusic(_ musicUrl:String)
    {
        let url = URL(string: musicUrl)
        if let requiredUrl = url {
            let player = AVPlayer(url: requiredUrl)
            // url can be remote or local
            let playerViewController = AVPlayerViewController()
            // creating a player view controller
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
