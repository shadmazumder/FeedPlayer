//
//  FeedPlayer.swift
//  FeedPlayer
//
//  Created by Shad Mazumder on 26/1/22.
//

import AVFoundation
import FeediOS

public struct FeedPlayer: PlayerDelegate {
    private var feedLogger: Logger
    
    public init(feedLogger: Logger) {
        self.feedLogger = feedLogger
    }
    
    public var player: AVPlayer{ AVPlayer() }
    
    public func logMessage(_ message: String?) {
        feedLogger.logMessage(message)
    }
}
