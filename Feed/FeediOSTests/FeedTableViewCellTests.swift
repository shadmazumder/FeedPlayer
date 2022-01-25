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
    func test_rendersFeedCell_onValidFeeds() {
        let sut = renderedSUT(with: [anyFeedMapper])
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
    
    func test_feedCell_rendersFeedProperty() {
        let feed = anyFeedMapper.model
        let sut = renderedSUT(with: [feed.mapper])
        
        let feedCell = sut.feedCell()
        
        XCTAssertEqual(feedCell.feedTitle.text, feed.title)
        XCTAssertEqual(feedCell.feedDescription.text, feed.description)
        
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
}
