//
//  VideoPlayer.swift
//  BluetoothScanner
//
//  Created by Talip on 15.06.2023.
//

import AVFoundation
import UIKit

class VideoPlayer {
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var isLoopingEnabled = false
    
    func playVideo(from url: URL, in view: UIView, isLoopingEnabled: Bool = false) {
        self.isLoopingEnabled = isLoopingEnabled
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)
        
        if isLoopingEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        }
        
        player?.play()
    }
    
    func stopVideo() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        if isLoopingEnabled {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        }
    }
    
    @objc private func handlePlayerDidFinishPlaying(notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }
}
