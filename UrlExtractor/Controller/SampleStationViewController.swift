//
//  MainChannelCollectionViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 17/05/21.
//

import UIKit

private let reuseIdentifier = "Cell"

enum MainChannelListDisplayMode {
    case list
    case grid
}

class MainChannelCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var channelCollectionView: UICollectionView!

    private (set) var collectionDisplayMode: MainChannelListDisplayMode = .grid
    
    let basicChannelListModel = BasicChannelModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Set collectionView dataSource and delegate
        channelCollectionView.delegate = self
        channelCollectionView.dataSource = self
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

// MARK: -
// MARK: Private Methods
// MARK: -

    private func setupNavigationBar() {
        self.navigationItem.title = "Sample Stations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"),style: .plain,target: self, action: #selector(toggleChannelsDisplayMode))
    }

    func loadStreamUrlViewControllerData(_ channelUrl:String,_ channelName:String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
//            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
//            streamUrlViewController.mainUrl = channelUrl
//            streamUrlViewController.mainSiteName = channelName
//        }
    }
    
    func displayWebView(websiteUrl: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let webViewController = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController {
            webViewController.websiteString = websiteUrl
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
       // let webVC = WebViewController.instantiate(url: websiteUrl, siteName: siteName)
       // self.navigationController?.pushViewController(webVC, animated: true)
    }

    @objc private func toggleChannelsDisplayMode() {
        switch self.collectionDisplayMode {
        case .list:
            collectionDisplayMode = .grid
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),style: .plain,target: self, action: #selector(toggleChannelsDisplayMode))
            
        case .grid:
            collectionDisplayMode = .list
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"),style: .plain,target: self, action: #selector(toggleChannelsDisplayMode))
        }
        channelCollectionView.reloadData()
    }
    
// MARK: -
// MARK: CollectionView DataSource and Delegate
// MARK: -

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return basicChannelListModel.numberOfChannels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionDisplayMode == .grid ? collectionView.dequeueReusableCell(withReuseIdentifier: "MainChannelsGridViewCell", for: indexPath) as! MainChannelCollectionViewCell : collectionView.dequeueReusableCell(withReuseIdentifier: "MainChannelsListViewCell", for: indexPath) as! MainChannelCollectionViewCell
        cell.channelImageView.image = UIImage(named: "\(basicChannelListModel.item(atIndexPath: indexPath))")
        cell.urlLabel.text = basicChannelListModel.item(atIndexPath: indexPath).websiteName
        cell.backgroundColor = .black
        cell.delegate = self
        cell.indexpath = indexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = basicChannelListModel.item(atIndexPath: indexPath)
        let websiteString = selectedItem.websiteUrl
        //if let websiteURL = URL(string: websiteString) {
            displayWebView(websiteUrl: websiteString)
        //}
    }

    //To create animation for collectionView cells
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

    //To set the width and height of collectionView cells dynamically based on deviceSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize.zero
        switch collectionDisplayMode {
        case .list:
            ///iPhone 8 Rows x 1 Columns
            ///iPad 12 Rows x 2 Columns as iPad has longer screen width, we can show 2 list cells too
            cellSize = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: channelCollectionView.bounds.size.width - 50, height: (channelCollectionView.bounds.size.height - 60)/8) :
                CGSize(width: (channelCollectionView.bounds.size.width - 50)/2 , height: (channelCollectionView.bounds.size.height - 60)/4)
        case .grid:
            ///iPhone 8 Rows x 2 Columns
            ///iPad 12 Rows x 4 Columns
            cellSize = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: (channelCollectionView.bounds.size.width - 32)/2, height: (channelCollectionView.bounds.size.width - 32)/2 + 30) :
                CGSize(width: (channelCollectionView.bounds.size.width - 50)/4, height: collectionView.bounds.size.height/12)
        }
        return cellSize
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

// MARK: -
// MARK: TableView Cell delegate
// MARK: -
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
        let alert = UIAlertController(title: "\(basicChannelListModel.item(atIndexPath: indexpath).websiteUrl)", message: "Please Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Visit Website", style: .default) { (action) in
            //if let websiteURL = URL(string: self.basicChannelListModel.item(atIndexPath: indexpath).websiteUrl) {
                self.displayWebView(websiteUrl: self.basicChannelListModel.item(atIndexPath: indexpath).websiteUrl)
            //}
        }
        let action2 = UIAlertAction(title: "Share Url", style: .default) { (action) in
            let items = [URL(string: self.basicChannelListModel.item(atIndexPath: indexpath).websiteUrl)]
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

