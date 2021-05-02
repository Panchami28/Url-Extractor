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
        self.navigationItem.title = "Search"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        submitButton.isEnabled = false
        urlTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
        loadData()
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

// MARK: -
// MARK: TextField extension
// MARK: -

extension UserUrlManagerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let result = verifyUrl()
        if result == true {
            submitButton.isEnabled = true
        } else {
            UIAlertController.showAlert("Error: \(urlTextField.text ?? "") doesn't seem to be a valid URL", self)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
