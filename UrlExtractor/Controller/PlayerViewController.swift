//
//  PlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 04/05/21.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {

    @IBOutlet weak var likeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playMusic(_ url: URL) {
      player = AVPlayer.init(url: url)
        player?.play()
    }
    
    func displayImage(_ mainChannel: String) {
        if let frame = contentOverlayView?.bounds {
            let imageView = UIImageView(image: UIImage(named: mainChannel))
            imageView.frame = frame
            contentOverlayView?.addSubview(imageView)
        }
        let likeButton = UIButton()
        likeButton.setTitle("Hello", for: .normal)
        likeButton.setTitleColor(.blue, for: .normal)
        likeButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        self.view.addSubview(likeButton)
    }
}
