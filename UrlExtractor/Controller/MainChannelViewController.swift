//
//  MainUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit
import SafariServices
import SystemConfiguration

class MainChannelViewController: UIViewController {

    @IBOutlet weak var webPageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainUrlTableView: UITableView!
    
    let basicChannel = BasicChannelModel()
    
// MARK: -
// MARK: View Lifecycle
// MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainUrlTableView.dataSource = self
        mainUrlTableView.delegate = self
        mainUrlTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
        //animateTableView()
    }
    
// MARK: -
// MARK: Private Methods
// MARK: -
    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
                self.navigationController?.pushViewController(streamUrlViewController, animated: true)
                streamUrlViewController.mainUrl = channelUrl
                streamUrlViewController.mainSiteName = channelName
        }
    }
    
   
    
    func displayWebView(websiteUrl: String?) {
        if let requiredUrl = websiteUrl, let  url = URL(string: requiredUrl) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = WebViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
    func animateTableView() {
        mainUrlTableView.reloadData()
        
        let cells = mainUrlTableView.visibleCells
        let tableHeight: CGFloat = mainUrlTableView.bounds.size.height
        for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            print(i)
            }
        var index = 0
               
           for a in cells {
               let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
               }, completion: nil)
                   
               index += 1
           }
    }
    
}

// MARK:
// MARK: - Table view data source and delegate
// MARK:

extension MainChannelViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicChannel.numberOfChannels()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainUrlTableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
        cell.logoImage.image = UIImage(named: "\(basicChannel.item(atIndexPath: indexPath))")
        cell.urlLabel.text = basicChannel.item(atIndexPath: indexPath).websiteUrl
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadStreamUrlViewControllerData(basicChannel.item(atIndexPath: indexPath).websiteUrl,"\(basicChannel.item(atIndexPath: indexPath))")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

extension MainChannelViewController: TableViewCellDelegate {
    func viewWebPageButtonClicked(indexPath: IndexPath) {
        displayWebView(websiteUrl: basicChannel.item(atIndexPath: indexPath).websiteUrl)
    }
}
