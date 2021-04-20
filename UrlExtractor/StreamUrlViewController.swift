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

class StreamUrlViewController: UIViewController {
        
    @IBOutlet weak var urlTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    
    var mainSiteName:String = ""
    var streamUrlArray = [String]()
    var patternList = ["\"streams\":\\[\\{\"url\":\"[^\"]*","https://media[^\"]*","http://stream[^\"]*"]
    var mainchannelImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        //urlTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
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
    func loadData(_ musicUrl:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let musicPlayerViewController = storyboard.instantiateViewController(identifier: "MusicPlayerViewController") as? MusicPlayerViewController {
            self.navigationController?.pushViewController(musicPlayerViewController, animated: true)
            musicPlayerViewController.musicUrl = musicUrl
            musicPlayerViewController.channelImage = mainchannelImage
        }
    }
    
    func callRequiredScrape(_ mainSiteName:String)
    {
        var mainUrl:String?
        switch mainSiteName {
        case "Radionet": streamUrlArray = []
           mainUrl = "https://www.radio.net/"
        case "ShalomBeats Radio": streamUrlArray = []
            mainUrl = "http://shalombeatsradio.com/"
        case "NammRadio": streamUrlArray = []
            mainUrl = "http://nammradio.com/"
        case "RadioMirchi": streamUrlArray = []
            mainUrl = "https://www.radiomirchi.com/"
        default: mainUrl = "https://www.radio.net/"
        }
        scrapeWebpage(mainUrl)
    }
    
    func scrapeWebpage(_ mainUrl:String?) {
        do{
            guard let mainUrl = mainUrl else {return}
            let content = try String(contentsOf: URL(string: mainUrl)!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body = doc.body()
                let script = try! body!.select("script")
                for tag:Element in script {
                    let myText = tag.data()
                    for pattern in patternList {
                        let p = Pattern.compile(pattern)
                        let m: Matcher = p.matcher(in: myText)
                        while( m.find() )
                        {
                            let json = m.group()
                            if let streamUrl = json {
                                //print("\(streamUrl)\n\n\n")
                                if let regex = try? NSRegularExpression(pattern: "http[^\"]*", options: .caseInsensitive) {
                                    let string = streamUrl as NSString
                                    regex.matches(in: streamUrl, options: [], range: NSRange(location: 0, length: string.length)).map {
                                        streamUrlArray.append(string.substring(with: $0.range))
                                    }
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
            //Error handle
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
        loadData(streamUrlArray[indexPath.row])
    }
    
}
