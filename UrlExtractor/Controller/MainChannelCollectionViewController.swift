//
//  MainChannelCollectionViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 05/05/21.
//

import UIKit
//import SafariServices

private let reuseIdentifier = "Cell"

class MainChannelCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mainUrlTableView: UITableView!
    @IBOutlet weak var channelCollectionView: UICollectionView!
    
    let basicChannel = BasicChannelModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Set collectionView dataSource and delegate
        channelCollectionView.delegate = self
        channelCollectionView.dataSource = self
        ///Register a custom collection cell
        channelCollectionView.register(UINib(nibName: "MainChannelCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "MainChannelCollectionViewCell")
        ///Set navigation title and rightBarButtonItem
        self.navigationItem.title = "Sample Stations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.bookmarks, target: self, action: #selector(switchToListView))
        ///Set tableView dataSource and delegate
        mainUrlTableView.dataSource = self
        mainUrlTableView.delegate = self
        ///Register a custom table cell
        mainUrlTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
        ///Initially make tableView hidden to avoid overlapping of collectionView and tableView
        mainUrlTableView.alpha = 0
    }

// MARK: -
// MARK: Private Methods
// MARK: -
    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainUrl = channelUrl
            streamUrlViewController.mainSiteName = channelName
        }
    }
    
    func displayWebView(websiteUrl: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let webViewController = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController {
            self.navigationController?.pushViewController(webViewController, animated: true)
            webViewController.websiteUrl = websiteUrl
        }
    }
    
    @objc func switchToListView() {
        //Make collectionView hidden
        channelCollectionView.alpha = 0
        //Make tableView visible
        mainUrlTableView.alpha = 1
        //Change navigation button to create an option to switch from tableView to collectionView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(switchToTableView))
    }
    
    @objc func switchToTableView() {
        //Make collectionView visble
        channelCollectionView.alpha = 1
        //Make tableView hidden
        mainUrlTableView.alpha = 0
        //Change navigatioBar button to provide an option to switch from collectionView to tableView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(switchToListView))
    }
    
// MARK: -
// MARK: UICollectionViewDataSource
// MARK: -
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return basicChannel.numberOfChannels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainChannelCollectionViewCell", for: indexPath) as! MainChannelCollectionViewCell
        cell.channelImageView.image = UIImage(named: "\(basicChannel.item(atIndexPath: indexPath))")
        cell.urlLabel.text = basicChannel.item(atIndexPath: indexPath).websiteName
        cell.backgroundColor = .black
        cell.delegate = self
        cell.indexpath = indexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadStreamUrlViewControllerData(basicChannel.item(atIndexPath: indexPath).websiteUrl,"\(basicChannel.item(atIndexPath: indexPath))")
    }
    
    //To create animation for collectionView cells
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    //To set the width and height of collectionView cells dynamically based on deviceSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     if UIDevice.current.userInterfaceIdiom == .phone {
        return CGSize(width: (channelCollectionView.bounds.size.width - 50)/2 , height: (channelCollectionView.bounds.size.height - 50)/3)
     } else {
        return CGSize(width: (channelCollectionView.bounds.size.width - 50)/4 , height: (channelCollectionView.bounds.size.height - 50)/4)
     }
     }
    
// MARK:
// MARK: - Table view data source and delegate
// MARK:
    
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
    
    //To create animation for tableView cells
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

// MARK: -
// MARK: CollectionView Cell delegate
// MARK: -

extension MainChannelCollectionViewController: MainChannelCollectionViewCellDelegate {
    func listButtonClicked(_ indexpath: IndexPath) {
        displayAlert(indexpath)
    }
}

extension MainChannelCollectionViewController: TableViewCellDelegate {
    func viewWebPageButtonClicked(indexPath: IndexPath) {
        displayAlert(indexPath)
    }
}

// MARK: -
// MARK: AlertController
// MARK: -
extension MainChannelCollectionViewController {
    func displayAlert(_ indexpath: IndexPath) {
        let alert = UIAlertController(title: "\(basicChannel.item(atIndexPath: indexpath).websiteUrl)", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Visit website", style: .default) { (action) in
            self.displayWebView(websiteUrl: self.basicChannel.item(atIndexPath: indexpath).websiteUrl)
        }
        let action2 = UIAlertAction(title: "Share Url", style: .default) { (action) in
            let items = [URL(string: self.basicChannel.item(atIndexPath: indexpath).websiteUrl)]
            let activityController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            self.presentActivityViewController(activityController)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancelAction)
        presentAlertController(alert)
    }
}
