//
//  ViewControllerComposerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest
import UIKit
import Feed
import FeediOS

struct FeedsViewControllerComposer{
    private let jsonFeedFileName: String
    private let logger: Logger
    
    init(jsonFeedFileName: String, logger: Logger = FeedLogger()) {
        self.jsonFeedFileName = jsonFeedFileName
        self.logger = logger
    }
    
    func feedItemViewController() -> FeedsViewController{
        let feedsViewController = feedStoryboard.instantiateInitialViewController() as! FeedsViewController
        defer{ configure(feedsViewController) }
        return feedsViewController
    }
    
    private let feedStoryboard: UIStoryboard = {
        let bundle = Bundle(for: FeedsViewController.self)
        return UIStoryboard(name: "Feeds", bundle: bundle)
    }()
    
    private func configure(_ feedsViewController: FeedsViewController){
        configureLocalLoader(for: feedsViewController, logErrorOn: logger)
    }
    
    private func configureLocalLoader(for feedsViewController: FeedsViewController, logErrorOn logger: Logger){
        let failableLoader = makeFailableLocalLoader()
        if let loader = failableLoader.localLoader {
            feedsViewController.loader = loader
        }else{
            logger.logMessage(failableLoader.errorMessage)
        }
    }
    
    private func makeFailableLocalLoader() -> (localLoader: LocalLoader?, errorMessage: String?){
        let allJsonPaths = Bundle.main.paths(forResourcesOfType: ".json", inDirectory: nil)
        
        guard let path = allJsonPaths.filter({ $0.contains(jsonFeedFileName) }).first else {
            return (nil, "Json file was not found on the path")
        }
        let localLoader = LocalLoader(uri: path, client: LocalClient(), feedGenerator: FeedGenerator())
        return (localLoader, nil)
    }
}

struct FeedLogger: Logger {
    func logMessage(_ message: String?) {}
}

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
    
    // MARK: - Helper
    private var anyInvalidJsonFileName = ""
    
    private func makeSUT(_ jsonFileName: String, logger: Logger = FeedLogger()) -> (sut: FeedsViewControllerComposer, feedsViewController: FeedsViewController){
        let composer = FeedsViewControllerComposer(jsonFeedFileName: jsonFileName, logger: logger)
        let feedViewController = composer.feedItemViewController()
        return (composer, feedViewController)
    }
}

private class LoggerSpy: Logger{
    var message: String?
    func logMessage(_ message: String?) {
        self.message = message
    }
}
