//
//  WebsiteStreamURLExtractor.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 18/05/21.
//

import Foundation
import AVKit

class WebsiteStreamURLExtractor {
// MARK: -
// MARK: variable declarations
// MARK: -
        var mainUrl:String = ""
        var mainSiteName:String = ""
        var streamUrlArray = [String]()
        var regexx = "(https?://)[-a-zA-Z0-9@:%._\\+~#=;]{2,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+;.~#?&//=]*)"
        private var favoriteStreamDataManager = FavoriteStreamDataManager()
        private var streamDataManager = StreamDataManager()
        private lazy var scrapingWebpageQueue = DispatchQueue(label: "ScrapeWebpageQueue")
    
// MARK: -
// MARK: Private methods
// MARK: -
            
        func scrapeWebpage(_ mainUrl:String?,completion: @escaping (_ streams: String)-> Void) {
            scrapingWebpageQueue.async { [weak self] in
                ///To ensure that completion block is fired only after all urls are fetched
                let myGroup = DispatchGroup()
                guard let mainUrl = mainUrl, let requiredUrl = URL(string: mainUrl) else {
                    completion("error")
                    return
                }
                do{
                    ///Get source code of entire webpage of given URL
                    let content = try String(contentsOf: requiredUrl)
                    print("Panchami_Debug:Source code : \(content)")
                    ///Parse the source code for given regex
                    if let pattern = self?.regexx,
                       let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                        let string = (content) as NSString
                        regex.matches(in: content, options: [], range: NSRange(location: 0, length: string.length)).map {
                            ///To indicate that a batch inside the group has started execution
                            myGroup.enter()
                            ///If match found, get the corresponding URL
                            let obtainedString = string.substring(with: $0.range)
                            let obtainedUrl = URL(string: obtainedString)
                            ///Check if corresponding URL is streamable or not
                            if let obtainedUrl = obtainedUrl {
                                self?.isPlayable(url: obtainedUrl) { (streamResult) in
                                    print(streamResult)
                                    ///If URL is streamable, append it to streamUrlArray for further processing
                                    if streamResult == true {
                                        self?.streamUrlArray.append(obtainedString)
                                        completion(obtainedString)
                                    }
                                    ///To indicate that a batch inside the group that had started executing has now finished its execution
                                    ///This should be called inside the completion handler only
                                   myGroup.leave()
                                }
                            }
                        }
                    }
                } catch {
                    completion("error")
                    print("Error while parsing:\(error)")
                }
                ///Notify the main thread when all members inside the group have finished their execution
                myGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                        if self?.streamUrlArray == [] {
                            completion("")
                        }
                    }
                }
            }
        }
 
    func isPlayable(url: URL, completion: @escaping (Bool) -> ()) {
        let asset = AVAsset(url: url)
        let playableKey = "playable"
        asset.loadValuesAsynchronously(forKeys: [playableKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            //Check the status of asset passed and store the result in isPlayable
            let isPlayable = status == .loaded
            DispatchQueue.main.async {
                completion(isPlayable)
            }
        }
    }
}


