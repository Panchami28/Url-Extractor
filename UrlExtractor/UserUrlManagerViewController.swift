//
//  TextBoxViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 21/04/21.
//

import UIKit

class UserUrlManagerViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
 
// MARK: -
// MARK: View Lifecycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.delegate = self
        //submitButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        urlTextField.text = ""
    }
    
// MARK: -
// MARK: IB Actions
// MARK: -
    
    @IBAction func viewButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let mainChannelViewController = storyboard.instantiateViewController(identifier: "MainChannelViewController") as? MainChannelViewController {
            self.navigationController?.pushViewController(mainChannelViewController, animated: true)
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       let result = verifyUrl()
        if result == true {
            loadData()
        } else {
            UIAlertController.showAlert("Error: \(urlTextField.text ?? "") doesn't seem to be a valid URL", self)
        }
    }
    
// MARK: -
// MARK: Private Methods
// MARK: -
    
    func verifyUrl () -> Bool {
        if let urlString = urlTextField.text {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func loadData() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let streamUrlViewController = storyboard.instantiateViewController(identifier: "StreamUrlViewController") as? StreamUrlViewController {
            self.navigationController?.pushViewController(streamUrlViewController, animated: true)
            streamUrlViewController.mainUrl = urlTextField.text ?? ""
        }
    }
    
}
// MARK: -
// MARK: Alert Controller extension
// MARK: -

extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UserUrlManagerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
