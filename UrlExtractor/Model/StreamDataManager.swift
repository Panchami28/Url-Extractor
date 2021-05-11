//
//  StreamDataManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 02/05/21.
//

import Foundation
import UIKit
import CoreData

class StreamDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [Stream]()
    var urlArray = [String]()
    
    func addData(_ streamUrl: String,_ mainSiteName: String) {
        //Check if item exists in db
        getData()
        //Get all urls and compare it with current streamUrl
        getUrl()
        if urlArray.contains(streamUrl) {
            //If already present, update item in db
            updateData(streamUrl,mainSiteName)
        } else {
            //Create a stream object
            let newStream = Stream(context: context)
            newStream.url = streamUrl
            newStream.mainChannel = mainSiteName
            newStream.date = NSDate() as Date
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
            let request = Stream.fetchRequest() as NSFetchRequest<Stream>
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
    
    func item(_ indexpath: IndexPath) -> Stream {
        return items[indexpath.row]
    }
    
    func getUrl() {
        for i in 0..<items.count {
            urlArray.append(items[i].url ?? "")
        }
    }
    
    func updateData(_ streamUrl: String, _ mainChannel: String) {
        var item = [Stream]()
        let request = Stream.fetchRequest() as NSFetchRequest<Stream>
        let predicate = NSPredicate(format: "url CONTAINS '\(streamUrl)'")
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
//MARK:-
//MARK: Array Extension
//MARK:
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

