//
//  ComposerTestsHelper.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest
import FeediOS

extension XCTestCase{
    func makeSUT(_ jsonFileName: String, logger: Logger = FeedLogger()) -> (sut: FeedsViewControllerComposer, feedsViewController: FeedsViewController){
        let composer = FeedsViewControllerComposer(jsonFeedFileName: jsonFileName, logger: logger)
        let feedViewController = composer.feedsViewController
        
        trackMemoryLeak(composer)
        trackMemoryLeak(feedViewController)
        
        return (composer, feedViewController)
    }
}
