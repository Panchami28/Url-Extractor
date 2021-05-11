////
////  MainUrlViewController.swift
////  UrlExtractor
////
////  Created by Panchami Rao on 14/04/21.
////
//
//import UIKit
////import SafariServices
//
//class MainChannelViewController: UIViewController {
//
//    @IBOutlet weak var webPageLoadingIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var mainUrlTableView: UITableView!
//    
//    let basicChannel = BasicChannelModel()
//    
//// MARK: -
//// MARK: View Lifecycle
//// MARK: -
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mainUrlTableView.dataSource = self
//        mainUrlTableView.delegate = self
//        self.navigationItem.title = "Sample Stations"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.bookmarks, target: self, action: #selector(collectionView))
//        navigationItem.backButtonTitle = "Home"
//        mainUrlTableView.separatorStyle = .none
//        mainUrlTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
//    }
//    
//// MARK: -
//// MARK: Private Methods
//// MARK: -
//    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String)
//    {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//            if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
//                self.navigationController?.pushViewController(streamUrlViewController, animated: true)
//                streamUrlViewController.mainUrl = channelUrl
//                streamUrlViewController.mainSiteName = channelName
//        }
//    }
//    
//    func displayWebView(websiteUrl: String?) {
////        if let requiredUrl = websiteUrl, let  url = URL(string: requiredUrl) {
////            let config = SFSafariViewController.Configuration()
////            config.entersReaderIfAvailable = true
////            let vc = SafariWebViewController(url: url, configuration: config)
////            present(vc, animated: true)
////        }
//    }
//    
//    @objc func collectionView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        if let mainChannelCollectionViewController = storyboard.instantiateViewController(identifier: "MainChannelCollectionViewController") as? MainChannelCollectionViewController {
//            self.navigationController?.pushViewController(mainChannelCollectionViewController, animated: true)
//        }
//    }
//    
//}
//
//// MARK:
//// MARK: - Table view data source and delegate
//// MARK:
//
//extension MainChannelViewController:UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return basicChannel.numberOfChannels()
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = mainUrlTableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
//        cell.logoImage.image = UIImage(named: "\(basicChannel.item(atIndexPath: indexPath))")
//        cell.urlLabel.text = basicChannel.item(atIndexPath: indexPath).websiteUrl
//        cell.indexPath = indexPath
//        cell.delegate = self
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        loadStreamUrlViewControllerData(basicChannel.item(atIndexPath: indexPath).websiteUrl,"\(basicChannel.item(atIndexPath: indexPath))")
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
//        cell.layer.transform = rotationTransform
//        cell.alpha = 0
//        UIView.animate(withDuration: 1.0) {
//            cell.layer.transform = CATransform3DIdentity
//            cell.alpha = 1.0
//        }
//    }
//}
//
//extension MainChannelViewController: TableViewCellDelegate {
//    func viewWebPageButtonClicked(indexPath: IndexPath) {
//        displayWebView(websiteUrl: basicChannel.item(atIndexPath: indexPath).websiteUrl)
//    }
//}
