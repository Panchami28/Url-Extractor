//
//  MainUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit

class MainChannelViewController: UIViewController {

    @IBOutlet weak var mainUrlTableView: UITableView!
    
    let mainChannelArray = ["RadioNet","RadioGarden","RetroFM","CBCListen","HindiRadio"]
    
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
    func loadData(_ ChannelName:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if ChannelName != "RadioGarden" && ChannelName != "HindiRadio" {
            if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
                self.navigationController?.pushViewController(streamUrlViewController, animated: true)
                streamUrlViewController.mainSiteName = ChannelName
            }
        } else {
            if let subChannelTableViewController = storyboard.instantiateViewController(identifier: "SubChannelTableViewController") as? SubChannelTableViewController {
                self.navigationController?.pushViewController(subChannelTableViewController, animated: true)
                subChannelTableViewController.mainChannel = ChannelName
            }
        }
    }
    
}

// MARK:
// MARK: - Table view data source and delegate
// MARK:

extension MainChannelViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainChannelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainUrlTableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
        cell.logoImage.image = UIImage(named: "\(mainChannelArray[indexPath.row])")
        cell.urlLabel.text = mainChannelArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(mainChannelArray[indexPath.row])
    }
}
