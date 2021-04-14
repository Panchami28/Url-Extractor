//
//  MainUrlViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit

class MainUrlViewController: UIViewController {

    @IBOutlet weak var mainUrlTableView: UITableView!
    
    let mainUrlArray = ["RadioNet","ShalomBeats Radio"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainUrlTableView.dataSource = self
        mainUrlTableView.delegate = self
    }
    
    func loadData(_ mainUrl:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let displayViewController = storyboard.instantiateViewController(identifier: "DisplayViewController") as? DisplayViewController {
            self.navigationController?.pushViewController(displayViewController, animated: true)
            displayViewController.mainSiteName = mainUrl
        }
    }

}

extension MainUrlViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainUrlArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainUrlTableView.dequeueReusableCell(withIdentifier: "MainUrlCell", for: indexPath)
        cell.textLabel?.text = mainUrlArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(mainUrlArray[indexPath.row])
    }
    
    
}
