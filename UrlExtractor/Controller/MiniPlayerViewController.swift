//
//  MiniPlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/05/21.
//

import UIKit
import AVKit

class MiniPlayerViewController: UIViewController {
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var streamUrl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var musicLoadingActivityIndicator: UIActivityIndicatorView!
    
    let recentStreamDataManager = StreamDataManager()
    let playerController = PlayerViewController()
    static var player : AVPlayer?
    var items : [Stream]?
    var isPlaying = false
    var streamingUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        musicLoadingActivityIndicator.isHidden = true
        getStreamUrl()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if isPlaying == true {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
            pauseMusic()
        }
        if isPlaying == false {
           isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic(streamingUrl)
        }
    }
    
    func getStreamUrl() {
        items = recentStreamDataManager.allItems()
        if let items = items {
            if items != [] {
                streamingUrl = items[0].url ?? ""
                channelImage.image = UIImage(named: items[0].mainChannel ?? "")
                streamUrl.text = streamingUrl
            }
        }
    }
    
    public func playMusic(_ musicUrl:String) {
        pauseMusic()
        if let reqdUrl = URL(string: musicUrl) {
            //let playerItem = AVPlayerItem(url: reqdUrl)
            MiniPlayerViewController.player = AVPlayer(url: reqdUrl)
            MiniPlayerViewController.player?.play()
        } else {
            //handle error
        }
    }
    
    public func pauseMusic() {
        MiniPlayerViewController.player?.pause()
    }
    
    @IBAction func tapPressed(_ sender: UITapGestureRecognizer) {
        self.present(playerController, animated: true) {
            self.playerController.instantiate(self.streamingUrl, self.items?[0].mainChannel ?? "",self)
        }
    }
}
