//
//  NetworkReachabilityManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 30/04/21.
//

import Foundation
import Reachability
import UIKit

class ReachabilityManager: NSObject {
   static  let shared = ReachabilityManager()  // 2. Shared instance
   
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .unavailable
    }
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.Connection = .unavailable
    
    // 5. Reachability instance for Network status monitoring
    let reachability = try! Reachability()
    
    @objc func reachabilityChanged(notification: Notification) {
       let reachability = notification.object as! Reachability
        switch reachability.connection {
       case .unavailable:
       debugPrint("Network became unreachable")
       case .wifi:
       debugPrint("Network reachable through WiFi")
       case .cellular:
       debugPrint("Network reachable through Cellular Data")
        case .none:
            debugPrint("No issues")
        }
    }
    
    func startMonitoring() {
       NotificationCenter.default.addObserver(self,
                 selector: #selector(self.reachabilityChanged),
                 name: Notification.Name.reachabilityChanged,
                   object: reachability)
      do{
        try reachability.startNotifier()
      } catch {
        debugPrint("Could not start reachability notifier")
      }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
       reachability.stopNotifier()
       NotificationCenter.default.removeObserver(self,name: Notification.Name.reachabilityChanged,object: reachability)
    }
}


