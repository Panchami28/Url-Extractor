//
//  RecentStreamTableViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 02/05/21.
//

import UIKit

class RecentStreamTableViewController: UITableViewController {
    @IBOutlet var recentTableView: UITableView!
    
    var streamDataManager = StreamDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        streamDataManager.getData()
    }
// MARK: -
// MARK: - Private Methods
// MARK: -
    
    

// MARK: -
// MARK: - Table view data source
// MARK: -

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        streamDataManager.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentTableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = streamDataManager.item(indexPath).url
        return cell
    }
}
