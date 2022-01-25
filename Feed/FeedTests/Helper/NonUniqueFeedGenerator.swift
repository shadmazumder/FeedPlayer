//
//  NonUniqueFeedGenerator.swift
//  FeedTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import Feed

struct NonUniqueFeedGenerator: UniqueFeedGenerator{
    func generateUnique(_ feeds: [FeedModel]) -> [FeedModel] {
        feeds
    }
}
