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
    
    func test_feedTableViewCell_rendersFeedProperty() {
        let feed = anyFeedMapper.model
        let feedContainerData = anyFeedContainerWithData([feed.mapper])
        let (sut, client) = makeSUT()
        sut.loadViewIfNeeded()
        client.completeWith(feedContainerData.data)
        
        let feedCell = sut.feedCell()
        
        XCTAssertEqual(feedCell.feedTitle.text, feed.title)
        XCTAssertEqual(feedCell.feedDescription.text, feed.description)
        
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
}
