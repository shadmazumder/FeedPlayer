//
//  PlayerView.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import AVKit

class PlayerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    private var playerLayer: AVPlayerLayer {
        let playerLayer = layer as! AVPlayerLayer
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player?.isMuted = true
        return playerLayer
    }
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
}
