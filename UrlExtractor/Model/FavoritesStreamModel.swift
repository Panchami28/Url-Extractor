//
//  FavoritesStreamModel.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import Foundation

struct FavoriteStream: Codable {
    var stream:String?
    var mainChannel:String?
}

class FavouritesStreamModel {
    fileprivate let streamListFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("StreamList.plist")
    
    private var streamList = [FavoriteStream]()
    
    func loadStreamUrl() {
        guard let streamListPath = streamListFilePath else {
            return
        }
        if let data = try? Data(contentsOf: streamListPath) {
            let decoder = PropertyListDecoder()
            do {
                streamList = try decoder.decode([FavoriteStream].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
    }
    
    func storeStreamUrl(item: FavoriteStream) {
        guard let streamListPath = streamListFilePath else {
            return
        }
        if let data = try? Data(contentsOf: streamListPath) {
            let decoder = PropertyListDecoder()
            do {
                streamList = try decoder.decode([FavoriteStream].self, from: data)
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
    
    func removeStreamUrl(indexpath: IndexPath) {
        guard let streamListPath = streamListFilePath else {
            return
        }
        streamList.remove(at: indexpath.row)
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
    
    func item(indexPath: IndexPath) -> FavoriteStream {
        return streamList[indexPath.row]
    }
}
