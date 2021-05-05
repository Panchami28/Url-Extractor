//
//  UIViewController+Convenience.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 05/05/21.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertController(_ alertController: UIAlertController) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = []
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
                alertController.modalPresentationStyle = .popover
                present(alertController, animated: true, completion: nil)
            }
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}

