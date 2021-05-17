//
//  RecentSearchViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 07/05/21.
//

import UIKit
//import SafariServices

class RecentSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recentSearchTableView: UITableView!
    
    var recentSearchManager = RecentSearchManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
        recentSearchManager.getData()
        recentSearchTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
    }
    
    func loadData(_ siteUrl: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainUrl = siteUrl
            //streamUrlViewController.mainSiteName = "RecentStation"
        }
    }
    
    func displayWebView(websiteUrl: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let webViewController = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController {
            self.navigationController?.pushViewController(webViewController, animated: true)
            webViewController.websiteString = websiteUrl
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentSearchManager.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentSearchTableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
        cell.urlLabel.text = recentSearchManager.item(indexPath).siteUrl
        cell.logoImage.image = UIImage(named: "RecentStation")
        cell.delegate  = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(recentSearchManager.item(indexPath).siteUrl ?? "")
    }

}

extension RecentSearchViewController: TableViewCellDelegate {
    func viewWebPageButtonClicked(indexPath: IndexPath) {
        displayWebView(websiteUrl: recentSearchManager.item(indexPath).siteUrl)
    }
}
