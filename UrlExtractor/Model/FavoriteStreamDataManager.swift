//
//  FavoriteStreamDataManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 04/05/21.
//

import Foundation
import UIKit
import CoreData

class FavoriteStreamDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [FavoriteStreams]()
    //var urlArray = [String]()
    
    func addData(_ streamUrl: String, _ mainSiteName:String) -> Bool {
        var urlArray = [String]()
        //Check if item exists in db
        getData()
        urlArray = getUrl(urlArray)
        if urlArray.contains(streamUrl) {
            return false
        } else {
            //Create a stream object
            let newStream = FavoriteStreams(context: context)
            newStream.url = streamUrl
            newStream.mainChannel = mainSiteName
            newStream.heartName = "filled"
            //Save the data into db
            do {
                try self.context.save()
            } catch {
                print("Error saving data")
            }
            //getData()
            return true
        }
    }
    
    func getData() {
        do {
            let request = FavoriteStreams.fetchRequest() as NSFetchRequest<FavoriteStreams>
            items = try context.fetch(request)
        } catch {
            print("Error fetching data")
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(_ indexpath: IndexPath) -> FavoriteStreams {
        return items[indexpath.row]
    }
    
    func getSelectedData(_ streamUrl: String) -> FavoriteStreams {
        var selectedItem = [FavoriteStreams]()
        do {
            let request = FavoriteStreams.fetchRequest() as NSFetchRequest<FavoriteStreams>
            let predicate = NSPredicate(format: "url CONTAINS '\(streamUrl)'")
            request.predicate = predicate
            selectedItem = try context.fetch(request)
        } catch {
            print("Error fetching data")
        }
        return selectedItem.first!
    }
    
    func getUrl(_ urlArray : [String]) -> [String] {
        var requiredArray = urlArray
        for i in 0..<items.count {
            requiredArray.append(items[i].url ?? "")
        }
        return requiredArray
    }
    
    func deleteData(_ item: FavoriteStreams) {
        //Delete data
        self.context.delete(item)
        //Save data
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
        getData()
    }
}
