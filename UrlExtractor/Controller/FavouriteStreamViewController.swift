//
//  FavouriteStreamViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import UIKit

class FavouriteStreamViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    fileprivate let streamListFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("StreamList.plist")
    var favouritesStreamModel = FavouritesStreamModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favouritesStreamModel.loadStreamUrl()
    }
    

}
//MARK: -
//MARK: TableView DataSorce and Delegate
//MARK: -

extension FavouriteStreamViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouritesStreamModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = favouritesStreamModel.item(indexPath: indexPath)
        return cell
    }
    
    
}
