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
    
    let viewController = ViewController()
    let likeButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    let popButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    private var favouriteStreamDataManager = FavoriteStreamDataManager()
    var musicUrl:String = ""
    var mainChannel:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isBeingDismissed {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
                self.navigationController?.pushViewController(vc, animated: true)
                vc.playMusic(musicUrl)
            }
        }
    }
    
    func instantiate(_ musicUrl: String,_ mainChannel: String,_ destinationVC: UIViewController) {
            self.musicUrl = musicUrl
            self.mainChannel = mainChannel
            self.playMusic(musicUrl)
            self.designLikeButton()
            //self.designPopButton()
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
        if let frame = contentOverlayView?.bounds {
            let imageView = UIImageView(image: UIImage(named: mainChannel))
            imageView.frame = frame
            contentOverlayView?.addSubview(imageView)
        }
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
    
    func designPopButton() {
        popButton.backgroundColor = .darkGray
        popButton.setImage(UIImage(systemName: "heart"), for: .normal)
        popButton.tintColor = .orange
        if UIDevice.current.userInterfaceIdiom == .pad {
            popButton.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.minY+100, width: 50, height: 50)
        } else {
            popButton.frame = CGRect(x: self.view.frame.midX-15, y: self.view.frame.minY+70, width: 50, height: 50)
        }
        popButton.layer.cornerRadius = 15
        popButton.addTarget(self, action: #selector(popButtonTapped), for: .touchUpInside)
        self.view.addSubview(popButton)
    }
    
    @objc func popButtonTapped() {
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let vc = storyboard.instantiateViewController(identifier: "MiniPlayerViewController") as? MiniPlayerViewController {
                vc.streamingUrl = self.musicUrl
            
            }
        }
    }
        
}


