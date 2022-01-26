//
//  PlayerProvider.swift
//  FeediOS
//
//  Created by Shad Mazumder on 25/1/22.
//

import AVFoundation

public protocol PlayerProvider{
    var player: AVPlayer {get}
}
