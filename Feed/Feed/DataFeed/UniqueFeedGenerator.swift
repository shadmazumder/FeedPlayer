//
//  UniqueFeedGenerator.swift
//  Feed
//
//  Created by Shad Mazumder on 25/1/22.
//

import Foundation

public protocol UniqueFeedGenerator {
    func generateUnique(_ feeds: [FeedModel]) -> [FeedModel]
}
