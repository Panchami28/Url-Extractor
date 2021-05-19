//
//  RootTabBarController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 18/05/21.
//

import UIKit

class RootTabBarController: UITabBarController {

    static let shared = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
//            if let rootVc = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
//                print("Tab  bar Controller is presented")
//            }
            self.tabBarController?.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 120, width: self.view.frame.width, height: 70)
            self.tabBarController?.view.addSubview(vc.view)
            self.willMove(toParent: self.tabBarController)
            //ServiceLocator.shared.playerManager
        }
    }


}
