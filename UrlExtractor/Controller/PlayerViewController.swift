//
//  PlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 04/05/21.
//

import UIKit
import AVKit
import Reachability

class PlayerViewController: AVPlayerViewController {

    @IBOutlet weak var likeButton: UIButton!
    
    let viewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func playMusic(_ url: URL) {
        //Check if network is available
        if viewController.reachability.connection == .unavailable {
            UIAlertController.showAlert("Network Unavailable!", self)
        } else {
            player = AVPlayer.init(url: url)
            player?.play()
        }
    }
    
    func displayImage(_ mainChannel: String) {
        if let frame = contentOverlayView?.bounds {
            let imageView = UIImageView(image: UIImage(named: mainChannel))
            imageView.frame = frame
            contentOverlayView?.addSubview(imageView)
        }
        let likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setTitleColor(.blue, for: .normal)
        likeButton.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
        self.view.addSubview(likeButton)
    }
}
