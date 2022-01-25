//
//  FeedTableViewCellTests.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import XCTest
import Feed
import FeediOS

class FeedTableViewCellTests: XCTestCase {
    func test_rendersFeedTableViewCell_onValidFeeds() {
        let feedContainerData = anyFeedContainerWithData([anyFeedMapper])
        let (sut, client) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        client.completeWith(feedContainerData.data)
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
}
