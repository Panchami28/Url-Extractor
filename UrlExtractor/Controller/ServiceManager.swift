//
//  ServiceManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 18/05/21.
//

import Foundation
import UIKit

class ServiceManager {
    static let shared = ServiceManager()
    
    var miniPlayerController = (UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController)!
    
    var rootTabBarController: UITabBarController {
        return (UIApplication.shared.windows.first?.rootViewController as? UITabBarController)! 
    }


    
//    func frameForMiniController(_ presentingVC: UIViewController) -> CGRect {
//            var miniRect = presentingVC.safeAreaLayoutGuide.layoutFrame
//            let height:CGFloat = <Hieght of Your Mini Player>
//            miniRect.origin.y = miniRect.maxY - height
//            miniRect.size.height = height
//            return miniRect
//        }
        
    func addMiniController(_ presentingVC: UIViewController) {
        let miniVC = ServiceManager.shared.miniPlayerController
        ServiceManager.shared.rootTabBarController.addChild(miniVC)
        miniVC.view.frame = CGRect(x: 0, y: presentingVC.view.frame.maxY - 120, width: presentingVC.view.frame.width, height: 70)
        miniVC.view.alpha = 1.0
        ServiceManager.shared.rootTabBarController.view.addSubview(miniVC.view)
        miniVC.didMove(toParent: ServiceManager.shared.rootTabBarController)
        miniVC.getStreamUrl()
        miniVC.updatePlayButton()
    }
}
