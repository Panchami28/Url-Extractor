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
    var musicUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        let url = URL(string: musicUrl)
        play(url: url!)
    }
    
    func play(url:URL) {
        print("playing \(url)")
        do {
            let playerItem = AVPlayerItem(url: url)
            self.player = try AVPlayer(playerItem:playerItem)
            player?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
}
