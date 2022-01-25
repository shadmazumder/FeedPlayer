//
//  FeedMapperProvider.swift
//  FeedTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import XCTest

extension XCTestCase{
    func anyFeedContainerWithData(_ feedMappers: [FeedModelMapper]) -> (feedContainerMapper: FeedContainerMapper, data: Data) {
        let feedContainer = FeedContainerMapper(feeds: feedMappers)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(feedContainer)

        return (feedContainer, data)
    }

    var anyFeedMapper: FeedModelMapper{
        FeedModelMapper(title: "any title", description: "any description", source: "any-source")
    }
}
