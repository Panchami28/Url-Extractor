//
//  StreamDataManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 02/05/21.
//

import Foundation
import UIKit

class StreamDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [Stream]()
    
    func addData(_ streamUrl: String,_ mainSiteName: String) {
        //Create a stream object
        let newStream = Stream(context: context)
        newStream.url = streamUrl
        newStream.mainChannel = mainSiteName
        //save the data
        do {
            try self.context.save()
        } catch {
            print("Error saving data")
        }
    }
    
    func getData() {
        do {
            self.items = try context.fetch(Stream.fetchRequest())
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
    
}
