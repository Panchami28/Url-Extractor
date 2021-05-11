//
//  RecentSearchManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 07/05/21.
//

import Foundation
import UIKit
import CoreData

class RecentSearchManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [RecentSearch]()
    var urlArray = [String]()
    
    func addData(_ siteUrl: String) {
        //Check if item exists in db
        getData()
        //Get all urls and compare it with current streamUrl
        getUrl()
        if urlArray.contains(siteUrl) {
            //If already present, update item in db
            updateData(siteUrl)
        } else {
            //Create a stream object
            let newSite = RecentSearch(context: context)
            newSite.siteUrl = siteUrl
            newSite.date = NSDate() as Date
            //Save the data into db
            do {
                try self.context.save()
            } catch {
                print("Error saving data")
            }
        }
    }
    
    func getData() {
        do {
            let request = RecentSearch.fetchRequest() as NSFetchRequest<RecentSearch>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchLimit = 10
            items = try context.fetch(request)
        } catch {
            print("Error fetching data")
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(_ indexpath: IndexPath) -> RecentSearch {
        return items[indexpath.row]
    }
    
    func getUrl() {
        for i in 0..<items.count {
            urlArray.append(items[i].siteUrl ?? "")
        }
    }
    
    func updateData(_ siteUrl: String) {
        var item = [RecentSearch]()
        let request = RecentSearch.fetchRequest() as NSFetchRequest<RecentSearch>
        let predicate = NSPredicate(format: "siteUrl CONTAINS '\(siteUrl)'")
        request.predicate = predicate
        do {
        item = try context.fetch(request)
        } catch {
            print("Error fetching data")
        }
        //Update data
        item.first?.date = NSDate() as Date
        //Save data
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
    
}


