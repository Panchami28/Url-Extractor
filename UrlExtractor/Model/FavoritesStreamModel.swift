//
//  FavoritesStreamModel.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import Foundation

class FavouritesStreamModel {
    fileprivate let streamListFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("StreamList.plist")
    var streamList = [String]()
    
    func loadStreamUrl() {
        guard let streamListPath = streamListFilePath else {
            return
        }
        if let data = try? Data(contentsOf: streamListPath) {
            let decoder = PropertyListDecoder()
            do {
                streamList = try decoder.decode([String].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
    }
    
    func storeStreamUrl(item: String) {
        guard let streamListPath = streamListFilePath else {
            return
        }
        if let data = try? Data(contentsOf: streamListPath) {
            let decoder = PropertyListDecoder()
            do {
                streamList = try decoder.decode([String].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
        streamList.append(item)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(streamList)
            try data.write(to: streamListPath)
        } catch {
            //show alert
            print("Error encoding data:\(error)")
        }
    }
    
    func numberOfRows() -> Int {
        return streamList.count
    }
    
    func item(indexPath: IndexPath) -> String {
        return streamList[indexPath.row]
    }
}
