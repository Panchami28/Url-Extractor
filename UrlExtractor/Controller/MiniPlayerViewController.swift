//
//  MiniPlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 14/05/21.
//

import UIKit
import AVKit
import MediaPlayer

class MiniPlayerViewController: UIViewController {
    
// MARK: -
// MARK: IB Outlets
// MARK: -
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var streamUrl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var musicLoadingActivityIndicator: UIActivityIndicatorView!

// MARK: -
// MARK: Varaiable declarations
// MARK: -
    
    let recentStreamDataManager = StreamDataManager()
    let playerController = PlayerViewController()
    static var player : AVPlayer?
    static var isPlaying = false
    var items: [Stream]?
    var streamingUrl: String?
    var channelImageName: String?

// MARK: -
// MARK: View Lifecycle
// MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        musicLoadingActivityIndicator.isHidden = true
        getStreamUrl()
        updatePlayButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updatePlayButton()
    }

// MARK: -
// MARK: IB Actions
// MARK: -
    @IBAction func tapPressed(_ sender: UITapGestureRecognizer) {
        self.present(playerController, animated: true) {
            if let streamingUrl = self.streamingUrl, let channelImageName = self.channelImageName {
                self.playerController.instantiate(streamingUrl, channelImageName,self)
            }
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if MiniPlayerViewController.isPlaying == true {
            MiniPlayerViewController.isPlaying = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pauseMusic()
        } else if MiniPlayerViewController.isPlaying == false {
            MiniPlayerViewController.isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            if let streamUrl = streamingUrl {
                playMusic(streamUrl)
            }
        }
    }
    
// MARK: -
// MARK: Private Functions
// MARK: -
    func getStreamUrl() {
        items = recentStreamDataManager.allItems()
        if let items = items {
            if items != [] {
                streamingUrl = items[0].url
                channelImageName = items[0].mainChannel
                if let streamingUrl = streamingUrl , let channelImageName = channelImageName {
                    channelImage.image = UIImage(named: channelImageName)
                    streamUrl.text = streamingUrl
                }
            }
        }
    }
    
    func updatePlayButton() {
        if MiniPlayerViewController.isPlaying == true {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func playMusic(_ musicUrl:String) {
        pauseMusic()
        if let reqdUrl = URL(string: musicUrl) {
            //let playerItem = AVPlayerItem(url: reqdUrl)
            MiniPlayerViewController.player = AVPlayer(url: reqdUrl)
            MiniPlayerViewController.player?.play()
            setupNowPlaying()
            setupRemoteCommandCenter()
        } else {
            //handle error
        }
    }
    
   func pauseMusic() {
        MiniPlayerViewController.player?.pause()
    }
    
    ///Below 2 functions are used to provide scroll notification and lock screen notification of  currently playing track
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        if let streamingUrl = streamingUrl, let image = UIImage(named: channelImageName ?? "") {
            nowPlayingInfo[MPMediaItemPropertyTitle] = streamingUrl
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) {
                (size) -> UIImage in
                return image
            }
        }
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            MiniPlayerViewController.player?.play()
            MiniPlayerViewController.isPlaying = true
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            MiniPlayerViewController.player?.pause()
            MiniPlayerViewController.isPlaying = false
            return .success
        }
    }
}

