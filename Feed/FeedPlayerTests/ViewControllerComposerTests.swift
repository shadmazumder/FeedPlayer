//
//  ViewControllerComposerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest

import FeediOS
import FeedPlayer

class ViewControllerComposerTests: XCTestCase {
    func test_invalidFeedJsonPath_doesNotInitiateLoader() {
        let (_, feedViewController) = makeSUT(anyInvalidJsonFileName)
        XCTAssertNil(feedViewController.loader)
    }
    
    func test_invalidFeedJsonPath_logsError() {
        let logger = LoggerSpy()
        let (_, _) = makeSUT(anyInvalidJsonFileName, logger: logger)
        XCTAssertNotNil(logger.message)
    }
    
    func test_ResourcesPaths_providesValidFeedsJsonFileName() {
        let feedsJsonFileName = ResourcePaths.feedsJsonFile
        XCTAssertNotNil(Bundle.main.path(forResource: feedsJsonFileName, ofType: ".json"))
    }
    
    func test_composer_composesFeedsViewController() {
        let (_ , feedViewController) = makeSUT(ResourcePaths.feedsJsonFile)
        XCTAssertNotNil(feedViewController.playerDelegate)
        XCTAssertNotNil(feedViewController.loader)
        XCTAssertNotNil(feedViewController.errorHandler)
    }
    
    // MARK: - Helper
    private var anyInvalidJsonFileName = ""
}

private class LoggerSpy: Logger{
    var message: String?
    func logMessage(_ message: String?) {
        self.message = message
    }
}
