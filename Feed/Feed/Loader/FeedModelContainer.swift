//
//  FeedModelContainer.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public struct FeedModelContainer: Decodable{
    public let feeds: [FeedModel]
    
    public init(feeds: [FeedModel]) {
        self.feeds = feeds
    }
}
