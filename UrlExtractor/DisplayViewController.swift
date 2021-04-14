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

class DisplayViewController: UIViewController {
        
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
    func callRequiredScrape(_ mainUrl:String)
    {
        switch mainUrl {
        case "Radionet": streamUrlArray = []
            scrapeRadionetWebpage("https://www.radio.net/")
        case "ShalomBeats Radio": streamUrlArray = []
            scrapeShalombeatsradioWebpage("http://shalombeatsradio.com/")
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
                    //print(tag)
                    streamUrlArray.append(tag)
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

extension DisplayViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamUrlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = urlTableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        cell.textLabel?.text = streamUrlArray[indexPath.row]
        return cell
    }
    
    
}
