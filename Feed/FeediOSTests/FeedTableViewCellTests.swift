//
//  FeedTableViewCellTests.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import XCTest
import Feed
import FeediOS
import AVFoundation

class FeedTableViewCellTests: XCTestCase {
    func test_rendersFeedCell_onValidFeeds() {
        let sut = renderedSUT(with: [anyFeedMapper])
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
    
    func test_feedCell_rendersFeedProperty() {
        let client = FeedClientSpy()
        let sut = launchesViewControllerFromFeedsSotyboard() as! FeedsViewController
        sut.loader = LocalLoader(uri: XCTestCase.anyURI, client: client, feedGenerator: NonUniqueFeedGenerator())
        
        let feed = anyFeedMapper.model
        let feedContainerData = anyFeedContainerWithData([feed.mapper])
        
        sut.loadViewIfNeeded()
        client.completeWith(feedContainerData.data)
        
        let feedCell = sut.feedCell()
        
        XCTAssertEqual(feedCell.feedTitle.text, feed.title)
        XCTAssertEqual(feedCell.feedDescription.text, feed.description)
        
        
        XCTAssertNotNil(sut.cell() as? FeedTableViewCell)
    }
    
    func test_willDisplay_playsVideo() {
        let sut = renderedSUT(with: [anyFeedMapper])
        let player = PlayerSpy()
        sut.playerDelegate = PlayerContainer(spyPlayer: player)
        sut.willDisplayCell()
        
        XCTAssertEqual(player.states, [.play])
    }
    
    func test_prepareReuse_resetTextOnLabels() {
        let sut = renderedSUT(with: [anyFeedMapper])
        let feedCell = sut.feedCell()
        
        feedCell.prepareForReuse()
        
        XCTAssertNil(feedCell.feedTitle.text)
        XCTAssertNil(feedCell.feedDescription.text)
    }
}

private class PlayerContainer: PlayerDelegate{
    var player: AVPlayer
    
    init(spyPlayer: PlayerSpy) {
        player = spyPlayer
    }
    
    func logMessage(_ message: String?) {}
}

private class PlayerSpy: AVPlayer{
    enum State {
        case play
    }
    
    var states = [State]()
    
    override func playImmediately(atRate rate: Float) {
        states.append(.play)
    }
}
