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
        PlayerManager.shared.loadMusicUrl(streamingUrl ?? "", channelImageName ?? "")
        updatePlayButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //getStreamUrl()
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
        if PlayerManager.shared.isPlaying == true {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            PlayerManager.shared.pauseMusic()
        } else if PlayerManager.shared.isPlaying == false {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            //if let streamUrl = streamingUrl,let channelImageName = channelImageName {
                PlayerManager.shared.playMusic()
            //}
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
        if PlayerManager.shared.isPlaying == true {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    
}

