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
    var mainSiteName:String = ""
    var streamUrlArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        callRequiredScrape(mainSiteName)
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
        }
    }
    
    func callRequiredScrape(_ mainUrl:String)
    {
        switch mainUrl {
        case "Radionet": streamUrlArray = []
            scrapeRadionetWebpage("https://www.radio.net/")
        case "ShalomBeats Radio": streamUrlArray = []
            scrapeShalombeatsradioWebpage("http://shalombeatsradio.com/")
        case "NammRadio": streamUrlArray = []
            scrapeNammradioWebpage("http://nammradio.com/")
        case "RadioMirchi": streamUrlArray = []
            scrapeRadiomirchiWebpage("https://www.radiomirchi.com/")
        default: scrapeRadionetWebpage("https://www.radio.net/")
        }
    }
    
    func scrapeRadionetWebpage(_ mainUrl:String) {
        do{
            let content = try String(contentsOf: URL(string: mainUrl)!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body = doc.body()
                let script = try! body!.select("script")
                for tag:Element in script {
                    let myText = tag.data()
                    //print("Datanode result:\(tag.dataNodes()[0])")
                    let p = Pattern.compile("\"streams\":\\[\\{\"url\":\"[^\"]*")
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if let streamUrl = json {
                            //print("\(streamUrl)\n\n\n")
                            let firstIndex = streamUrl.index(streamUrl.startIndex, offsetBy: 18)
                            let lastIndex = streamUrl.index(streamUrl.endIndex, offsetBy: -2)
                            let appendingUrl = streamUrl[firstIndex...lastIndex]
                            streamUrlArray.append(String(appendingUrl))
                        }
                    }
                }
            }
        } catch {
            //Error handle
        }
    }
    
    func scrapeShalombeatsradioWebpage(_ mainUrl:String) {
        do{
            let content = try String(contentsOf: URL(string: mainUrl)!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let requiredCode = try doc.getElementsByClass("cc_streaminfo")
                for element:Element in requiredCode {
                    let tag = try element.attr("href")
                    streamUrlArray.append(tag)
                }
            }
        } catch {
            //Error handle
        }
    }
    
    func scrapeNammradioWebpage(_ mainUrl:String) {
        do{
            let content = try String(contentsOf: URL(string: mainUrl)!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body = doc.body()
                let script = try! body!.select("script")
                for tag:Element in script {
                    let myText = tag.data()
                    let p = Pattern.compile("mp3: \"[^\"]*")
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if let streamUrl = json {
                            let firstIndex = streamUrl.index(streamUrl.startIndex, offsetBy: 6)
                            let appendingUrl = streamUrl[firstIndex...]
                            streamUrlArray.append(String(appendingUrl))
                            print("\(streamUrl)\n")
                        }
                    }
                }
            }
        } catch {
            //Error handle
        }
    }
    
    func scrapeRadiomirchiWebpage(_ mainUrl:String) {
        do{
            let content = try String(contentsOf: URL(string: mainUrl)!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body = doc.body()
                let script = try! body!.select("script")
                for tag:Element in script {
                    let myText = tag.data()
                    let p = Pattern.compile("mp3:\"[^\"]*")
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if let streamUrl = json {
                            if streamUrl.starts(with: "mp3:") {
                                let firstIndex = streamUrl.index(streamUrl.startIndex, offsetBy: 5)
                                let appendingUrl = streamUrl[firstIndex...]
                                streamUrlArray.append(String(appendingUrl))
                            } else {
                                let firstIndex = streamUrl.index(streamUrl.startIndex, offsetBy: 1)
                                let lastIndex = streamUrl.index(streamUrl.endIndex, offsetBy: -5)
                                let appendingUrl = streamUrl[firstIndex...lastIndex]
                                streamUrlArray.append(String(appendingUrl))
                            }
                        }
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
