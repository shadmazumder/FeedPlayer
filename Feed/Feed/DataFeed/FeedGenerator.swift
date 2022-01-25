//
//  FeedGenerator.swift
//  Feed
//
//  Created by Shad Mazumder on 25/1/22.
//

import Foundation

public struct FeedGenerator: UniqueFeedGenerator {
    public init() {}
    
    public func generateUnique(_ feeds: [FeedModel]) -> [FeedModel]{
        feeds.compactMap { FeedModel(title: unique($0.title),
                                description: unique($0.description),
                                source: $0.source) }
    }
    
    private func unique(_ text: String) -> String{
        text + " " + UUID().uuidString
    }
}

