//
//  PlayerManager.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 17/05/21.
//

import Foundation
import AVKit
import MediaPlayer

class PlayerManager {
    static let shared = PlayerManager()
    var player : AVPlayer?
    var isPlaying = false
    
    func loadMusicUrl(_ musicUrl:String,_ mainChannel: String) {
        if let reqdUrl = URL(string: musicUrl) {
            player = AVPlayer(url: reqdUrl)
        } else {
            //handle Error
        }
        setupNowPlaying(musicUrl, mainChannel)
        setupRemoteCommandCenter()
    }
    
        func playMusic() {
            isPlaying = true
            player?.play()
            
        }
        
    func playMusic(_ musicUrl:String,_ mainChannel: String) {
        pauseMusic()
        if let reqdUrl = URL(string: musicUrl) {
            player = AVPlayer(url: reqdUrl)
            player?.play()
            isPlaying = true
            setupNowPlaying(musicUrl, mainChannel)
            setupRemoteCommandCenter()
        } else {
            //handle error
        }
    }
    
    func pauseMusic() {
        player?.pause()
        isPlaying = false
    }
    
    ///Below 2 functions are used to provide scroll notification and lock screen notification of  currently playing track
    func setupNowPlaying(_ musicUrl: String, _ mainChannel: String) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        if let image = UIImage(named: mainChannel) {
            nowPlayingInfo[MPMediaItemPropertyTitle] = musicUrl
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
            self.player?.play()
            //isPlaying = true
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.player?.pause()
            //isPlaying = false
            return .success
        }
    }
}
