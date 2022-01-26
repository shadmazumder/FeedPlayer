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
    
    init(jsonFeedFileName: String) {
        self.jsonFeedFileName = jsonFeedFileName
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
        configureLocalLoader(for: feedsViewController)
    }
    
    private func configureLocalLoader(for feedsViewController: FeedsViewController){
        let failableLoader = makeFailableLocalLoader()
        if let loader = failableLoader.localLoader {
            feedsViewController.loader = loader
        }
    }
    
    private func makeFailableLocalLoader() -> (localLoader: LocalLoader?, errorMessage: String?){
        guard let path = Bundle.main.path(forResource: jsonFeedFileName, ofType: ".json") else {
            return (nil, "Json file was not found on the path")
        }
        let localLoader = LocalLoader(uri: path, client: LocalClient(), feedGenerator: FeedGenerator())
        return (localLoader, nil)
    }
}

class ViewControllerComposerTests: XCTestCase {
    func test_invalidFeedJsonPath_doesNotInitiateLoader() {
        let invalidJsonFileName = ""
        let composer = FeedsViewControllerComposer(jsonFeedFileName: invalidJsonFileName)
        let feedViewController = composer.feedItemViewController()
        XCTAssertNil(feedViewController.loader)
    }
}
