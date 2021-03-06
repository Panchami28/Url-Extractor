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
    
    func loadData(_ mainUrl:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if mainUrl != "RadioGarden" {
            if let displayViewController = storyboard.instantiateViewController(identifier: "DisplayViewController") as? StreamUrlViewController {
                self.navigationController?.pushViewController(displayViewController, animated: true)
                displayViewController.mainSiteName = mainUrl
            }
        } else {
            if let subChannelTableViewController = storyboard.instantiateViewController(identifier: "SubChannelTableViewController") as? SubChannelTableViewController {
                self.navigationController?.pushViewController(subChannelTableViewController, animated: true)
        }
    }
    }
}

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
        loadData(mainUrlArray[indexPath.row])
    }
    
}
