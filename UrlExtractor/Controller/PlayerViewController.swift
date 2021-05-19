//
//  PlayerViewController.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 04/05/21.
//

import UIKit
import AVKit
import Reachability
import MediaPlayer

class PlayerViewController: AVPlayerViewController {
    
    let viewController = HomeScreenViewController()
    let likeButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let cancelButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let moreButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    private var favouriteStreamDataManager = FavoriteStreamDataManager()
    var musicUrl:String = ""
    var mainChannel:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showsPlaybackControls = false
    }
    
    
    func instantiate(_ musicUrl: String,_ mainChannel: String,_ destinationVC: UIViewController) {
        self.musicUrl = musicUrl
        self.mainChannel = mainChannel
        //self.playMusic(musicUrl)
        self.designLikeButton()
        self.designPlayButton()
        self.designCancelButton()
        self.designMoreButton()
        self.displayImage()
    }
    
    
    func playMusic(_ musicUrl: String) {
        //Check if network is available
        if viewController.reachability.connection == .unavailable {
            UIAlertController.showAlert("Network Unavailable!", self)
        } else {
            let url = URL(string: musicUrl)
            if let requiredUrl = url {
                player = AVPlayer.init(url: requiredUrl)
                player?.play()
            } else {
                UIAlertController.showAlert("Unable to play the track", self)
            }
        }
    }
    
    func displayImage() {
        let frame = CGRect(x: self.view.frame.minX+60, y: self.view.frame.minY+100, width: self.view.frame.width-120, height: self.view.frame.height-400)
        let imageView = UIImageView(image: UIImage(named: mainChannel))
        imageView.frame = frame
        contentOverlayView?.addSubview(imageView)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let volumeView = MPVolumeView(frame: CGRect(x: self.view.frame.maxX-200, y: self.view.frame.minY+50, width: 150, height: 100))
            view.addSubview(volumeView)
        } else {
            let volumeView = MPVolumeView(frame: CGRect(x: self.view.frame.minX+50, y: self.view.frame.maxY-100, width: 150, height: 100))
            view.addSubview(volumeView)
        }
    }

    
    func designLikeButton() {
        //likeButton.backgroundColor = .white
        let favUrlArray = favouriteStreamDataManager.getUrl()
        if favUrlArray.contains(musicUrl) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .green
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            likeButton.frame = CGRect(x: self.view.frame.minX+100, y: self.view.frame.maxY-250, width: 50, height: 50)
        } else {
            likeButton.frame = CGRect(x: self.view.frame.minX+65, y: self.view.frame.maxY-245, width: 50, height: 50)
        }
        likeButton.layer.cornerRadius = 15
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        self.view.addSubview(likeButton)
    }
    
    @objc func likeButtonTapped() {
        let favUrlArray = favouriteStreamDataManager.getUrl()
        if favUrlArray.contains(musicUrl) {
            let alert = UIAlertController(title: "Warning!" , message: "\(musicUrl) already in favourites list. Do you wanna unfavourite it?", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                let selectedItem = self.favouriteStreamDataManager.getSelectedData(self.musicUrl)
                self.favouriteStreamDataManager.deleteData(selectedItem)
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.tintColor = .white
            }
            let cancelAction = UIAlertAction(title: "No", style: .default)
            alert.addAction(action1)
            alert.addAction(cancelAction)
            presentAlertController(alert)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .green
            favouriteStreamDataManager.addData(self.musicUrl,self.mainChannel)
        }
    }
    
    func designCancelButton() {
        cancelButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        cancelButton.tintColor = .white
        if UIDevice.current.userInterfaceIdiom == .pad {
            cancelButton.frame = CGRect(x: self.view.frame.minX+60, y: self.view.frame.minY+20, width: 50, height: 50)
        } else {
            cancelButton.frame = CGRect(x: self.view.frame.midX-10, y: self.view.frame.minY+50, width: 50, height: 50)
        }
        cancelButton.layer.cornerRadius = 20
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func designPlayButton() {
        playButton.backgroundColor = .white
        if PlayerManager.shared.isPlaying == true {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        playButton.tintColor = .black
        if UIDevice.current.userInterfaceIdiom == .pad {
            playButton.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.maxY-250, width: 50, height: 50)
        } else {
           playButton.frame = CGRect(x: self.view.frame.midX-10, y: self.view.frame.maxY-250, width: 70, height: 70)
        }
        playButton.layer.cornerRadius = 30
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    @objc func playButtonTapped() {
            if PlayerManager.shared.isPlaying == true {
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                PlayerManager.shared.pauseMusic()
            } else if PlayerManager.shared.isPlaying == false {
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                PlayerManager.shared.playMusic()
                //PlayerManager.shared.playMusic(musicUrl,mainChannel)
            }
    }
    
    func designMoreButton() {
        moreButton.setImage(UIImage(named: "Moreicon"), for: .normal)
        moreButton.tintColor = .white
        if UIDevice.current.userInterfaceIdiom == .pad {
            moreButton.frame = CGRect(x: self.view.frame.maxX-150, y: self.view.frame.maxY-250, width: 50, height: 50)
        } else {
            moreButton.frame = CGRect(x: self.view.frame.maxX-70, y: self.view.frame.maxY-245, width: 50, height: 50)
        }
        moreButton.layer.cornerRadius = 15
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        self.view.addSubview(moreButton)
    }
    
    @objc func moreButtonTapped() {
        let alert = UIAlertController(title: "Options", message: "Choose", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Share Url", style: .default) { (action) in
            let items = [self.musicUrl]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.presentActivityViewController(activityVC)
        }
        let action2 = UIAlertAction(title: "Sleep timer", style: .default) { (action) in
            self.setTimerFeature()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancelAction)
        presentAlertController(alert)
    }
    
    func setTimerFeature() {
        let subAlert = UIAlertController(title: "Options", message: "Choose timer", preferredStyle: .actionSheet)
        let subAction1 = UIAlertAction(title: "5 minutes", style: .default) { (action) in
           Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
            self.setPlayButtonAfterTimer()
            }
        }
        let subAction2 = UIAlertAction(title: "10 minutes", style: .default) { (action) in
           Timer.scheduledTimer(withTimeInterval: 10*60, repeats: false) { (timer) in
            self.setPlayButtonAfterTimer()
            }
        }
        let subAction3 = UIAlertAction(title: "30 minutes", style: .default) { (action) in
           Timer.scheduledTimer(withTimeInterval: 30*60, repeats: false) { (timer) in
            self.setPlayButtonAfterTimer()
            }
        }
        let subAction4 = UIAlertAction(title: "1 hour", style: .default) { (action) in
           Timer.scheduledTimer(withTimeInterval: 60*60, repeats: false) { (timer) in
            self.setPlayButtonAfterTimer()
            }
        }
        subAlert.addAction(subAction1)
        subAlert.addAction(subAction2)
        subAlert.addAction(subAction3)
        subAlert.addAction(subAction4)
        presentAlertController(subAlert)
    }
        
    func setPlayButtonAfterTimer() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        PlayerManager.shared.pauseMusic()
        //MiniPlayerViewController.isPlaying = false
    }
}


