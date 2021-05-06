//
//  MainChannelCollectionViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 05/05/21.
//

import UIKit
import SafariServices

private let reuseIdentifier = "Cell"

class MainChannelCollectionViewController: UICollectionViewController {

    let basicChannel = BasicChannelModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "MainChannelCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "MainChannelCollectionViewCell")
        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        let layout =  self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width * 0.3, height: height * 0.3)
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
        if let requiredUrl = websiteUrl, let  url = URL(string: requiredUrl) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = WebViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
// MARK: -
// MARK: UICollectionViewDataSource
// MARK: -
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return basicChannel.numberOfChannels()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainChannelCollectionViewCell", for: indexPath) as! MainChannelCollectionViewCell
        cell.channelImageView.image = UIImage(named: "\(basicChannel.item(atIndexPath: indexPath))")
        cell.urlLabel.text = basicChannel.item(atIndexPath: indexPath).websiteName
        cell.backgroundColor = .black
        cell.delegate = self
        cell.indexpath = indexPath
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadStreamUrlViewControllerData(basicChannel.item(atIndexPath: indexPath).websiteUrl,"\(basicChannel.item(atIndexPath: indexPath))")
    }
    
}

// MARK: -
// MARK: CollectionView Cell delegate
// MARK: -

extension MainChannelCollectionViewController: MainChannelCollectionViewCellDelegate {
    func listButtonClicked(_ indexpath: IndexPath) {
        let alert = UIAlertController(title: "\(basicChannel.item(atIndexPath: indexpath).websiteUrl)", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Visit website", style: .default) { (action) in
            self.displayWebView(websiteUrl: self.basicChannel.item(atIndexPath: indexpath).websiteUrl)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action1)
        alert.addAction(action2)
        presentAlertController(alert)
    }
}

//extension MainChannelCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = self.collectionView.frame.size.height
//        let width = self.collectionView.frame.size.width
//        // in case you you want the cell to be 40% of your controllers view
//        return CGSize(width: width * 0.5, height: height * 0.5)
//    }
//}