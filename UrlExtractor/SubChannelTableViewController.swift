//
//  SubChannelTableViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 15/04/21.
//

import UIKit

class SubChannelTableViewController: UITableViewController {
    
    @IBOutlet var subChannelTableView: UITableView!
    var mainChannel:String = ""
    
    var subChannel = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubChannelArray()
        subChannelTableView.register(UINib(nibName: "BasicUrlCell", bundle: nil), forCellReuseIdentifier: "BasicUrlCell")
    }

// MARK:
// MARK: - Table view data source and delegate
// MARK:
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subChannel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicUrlCell", for: indexPath) as! BasicUrlCell
        cell.logoImage.image = UIImage(named: subChannel[indexPath.row])
        cell.urlLabel.text = subChannel[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(subChannel[indexPath.row])
    }

// MARK:
// MARK: - Private Methods
// MARK:

    func setSubChannelArray()
    {
        switch mainChannel {
        case "RadioGarden": subChannel = ["ShalomBeats Radio","NammRadio","RadioMirchi"]
        case "HindiRadio": subChannel = ["Indian Australian Radio","Bombay Beats","RadioCity Hindi"]
        default: subChannel = []
        }
    }
    
    func loadData(_ channelName:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainSiteName = channelName
        }
    }
}
