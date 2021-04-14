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
    var streamUrlArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTableView.dataSource = self
        urlTableView.delegate = self
        //loadWebpage()
        scrapeWebpage()
        self.urlTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
//    func loadWebpage() {
//        let url = URL(string: "https://www.radio.net/s/ndr2")!
//        self.webView.load(URLRequest(url: url))
//        //webView.allowsBackForwardNavigationGestures = true
//        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "loading" {
//            if webView.isLoading {
//                loadingPageActivityIndicator.isHidden = false
//            } else {
//                loadingPageActivityIndicator.isHidden = true
//            }
//        }
//    }
        
    func scrapeWebpage() {
        do{
            let content = try String(contentsOf: URL(string: "https://www.radio.net/")!)
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body = doc.body()
                let script = try! body!.select("script")
                for tag:Element in script {
                    let myText = tag.data()
                    //print("Datanode result:\(tag.dataNodes()[0])")
                    let p = Pattern.compile("\"streams\":\\[\\{\"url\":\"[^,]*")
                    //let p = Pattern.compile("https\\:\\/\\/.*.mp3")
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if let streamUrl = json {
                            print("\(streamUrl)\n\n\n")
                            
                            streamUrlArray.append(streamUrl)
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
