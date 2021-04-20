//
//  MusicViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 16/04/21.
//

import UIKit
import AVFoundation
import AVKit

class MusicViewController: AVPlayerViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    var musicUrl:String = ""
    var channelImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowsPictureInPicturePlayback = true
        showsPlaybackControls = true
        let url = URL(string: musicUrl)
        let player = AVPlayer(url: url!) // url can be remote or local
        let playerViewController = AVPlayerViewController()
        // creating a player view controller
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        // Do any additional setup after loading the view.
    }
    
    

}
