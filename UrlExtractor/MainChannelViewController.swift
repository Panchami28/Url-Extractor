//
//  MainUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit

class MainChannelViewController: UIViewController {

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
    }
    
// MARK: -
// MARK: Private Methods
// MARK: -
    func loadData(_ channelUrl:String,_ channelName:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
                self.navigationController?.pushViewController(streamUrlViewController, animated: true)
                streamUrlViewController.mainUrl = channelUrl
                streamUrlViewController.mainSiteName = channelName
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(basicChannel.item(atIndexPath: indexPath).websiteUrl,"\(basicChannel.item(atIndexPath: indexPath))")
    }
}
