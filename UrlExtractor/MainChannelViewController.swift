//
//  MainUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit

class MainChannelViewController: UIViewController {

    @IBOutlet weak var mainUrlTableView: UITableView!
    
    let mainUrlArray = ["RadioNet","RadioGarden"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainUrlTableView.dataSource = self
        mainUrlTableView.delegate = self
        mainUrlTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
    }
    
    func loadData(_ mainUrl:String,_ mainChannelImage:UIImage)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if mainUrl != "RadioGarden" {
            if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
                self.navigationController?.pushViewController(streamUrlViewController, animated: true)
                streamUrlViewController.mainSiteName = mainUrl
                streamUrlViewController.mainchannelImage = mainChannelImage
            }
        } else {
            if let subChannelTableViewController = storyboard.instantiateViewController(identifier: "SubChannelTableViewController") as? SubChannelTableViewController {
                self.navigationController?.pushViewController(subChannelTableViewController, animated: true)
            }
        }
    }
}

// MARK:
// MARK: - Table view data source and delegate
// MARK:

extension MainChannelViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainUrlArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainUrlTableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
        cell.logoImage.image = UIImage(named: "\(mainUrlArray[indexPath.row])")
        cell.urlLabel.text = mainUrlArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let logoImage = UIImage(named: "\(mainUrlArray[indexPath.row])") {
            loadData(mainUrlArray[indexPath.row],logoImage)
        }
    }
    
}
