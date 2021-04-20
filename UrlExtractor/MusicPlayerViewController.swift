//
//  MusicPlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/04/21.
//

import UIKit
import AVKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var musicUrl:String = ""
    var channelImage:UIImage?
    
    @IBOutlet weak var playingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playingActivityIndicator.isHidden = true
        //logoImageView?.image = channelImage
        let url = URL(string: musicUrl)
        let player = AVPlayer(url: url!) // url can be remote or local
        let playerViewController = AVPlayerViewController()
        // creating a player view controller
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        let url = URL(string: musicUrl)
        play(url: url!)
        playingActivityIndicator.isHidden = false
    }
    
    func play(url:URL) {
        print("playing \(url)")
        do {
            playerItem = AVPlayerItem(url: url)
            self.player = try AVPlayer(playerItem:playerItem)
            player?.play()
            player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! NSObject == player && keyPath == "status") {
            if (player?.status == AVPlayer.Status.readyToPlay) {
                playingActivityIndicator.isHidden = true
            } else if (player?.status == AVPlayer.Status.failed) {
        // something went wrong. player.error should contain some information
        }
        }
    }
    
    
}
