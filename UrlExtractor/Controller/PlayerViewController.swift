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
    
    let viewController = ViewController()
    let likeButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let cancelButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    private var favouriteStreamDataManager = FavoriteStreamDataManager()
    var musicUrl:String = ""
    var mainChannel:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showsPlaybackControls = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        if self.isBeingDismissed {
//            let storyboard = UIStoryboard(name: "Main", bundle: .main)
//            if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
//                self.navigationController?.pushViewController(vc, animated: true)
//                vc.playMusic(musicUrl)
//            }
//        }
    }
    
    func instantiate(_ musicUrl: String,_ mainChannel: String,_ destinationVC: UIViewController) {
        self.musicUrl = musicUrl
        self.mainChannel = mainChannel
        //self.playMusic(musicUrl)
        self.designLikeButton()
        self.designPlayButton()
        self.designCancelButton()
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
        let volumeView = MPVolumeView(frame: CGRect(x: self.view.frame.maxX-200, y: self.view.frame.minY+50, width: 150, height: 100))
        view.addSubview(volumeView)
    }

    
    func designLikeButton() {
        likeButton.backgroundColor = .darkGray
        let favUrlArray = favouriteStreamDataManager.getUrl()
        if favUrlArray.contains(musicUrl) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .green
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            likeButton.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.minY+20, width: 50, height: 50)
        } else {
            likeButton.frame = CGRect(x: self.view.frame.midX-15, y: self.view.frame.minY+50, width: 50, height: 50)
        }
        likeButton.layer.cornerRadius = 15
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        self.view.addSubview(likeButton)
    }
    
    @objc func likeButtonTapped() {
        let favUrlArray = favouriteStreamDataManager.getUrl()
        if favUrlArray.contains(musicUrl) {
            let selectedItem = favouriteStreamDataManager.getSelectedData(musicUrl)
            favouriteStreamDataManager.deleteData(selectedItem)
            let alert = UIAlertController(title: "Warning!" , message: "\(musicUrl) already in favourites list. Do you wanna unfavourite it?", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
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
        cancelButton.backgroundColor = .darkGray
        cancelButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        cancelButton.tintColor = .white
        if UIDevice.current.userInterfaceIdiom == .pad {
            cancelButton.frame = CGRect(x: self.view.frame.minX+60, y: self.view.frame.minY+20, width: 50, height: 50)
        } else {
            cancelButton.frame = CGRect(x: self.view.frame.midX-15, y: self.view.frame.minY+50, width: 50, height: 50)
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
//        if vc.isPlaying == true {
//            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        }
//        if vc.isPlaying == false {
//            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        }
        playButton.tintColor = .black
        if UIDevice.current.userInterfaceIdiom == .pad {
            playButton.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.maxY-250, width: 50, height: 50)
        } else {
            playButton.frame = CGRect(x: self.view.frame.midX-15, y: self.view.frame.minY+70, width: 100, height: 70)
        }
        playButton.layer.cornerRadius = 20
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    @objc func playButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController{
            if vc.isPlaying == true {
                vc.isPlaying = false
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                vc.pauseMusic()
            }
            if vc.isPlaying == false {
                vc.isPlaying = true
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                vc.playMusic(musicUrl)
            }
        }
    }
        
}


