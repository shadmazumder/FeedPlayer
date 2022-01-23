//
//  FeediOSTests.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 24/1/22.
//

import XCTest
import FeediOS


class FeediOSTests: XCTestCase {
    func test_loadFromStoryboard_returnsFeedViewController() {
        XCTAssertTrue(launchesViewControllerFromFeedsSotyboard() is FeedsViewController, "Initial ViewController is not FeedsViewController")
    }
    
    // MARK: - Helper
    private func launchesViewControllerFromFeedsSotyboard() -> UIViewController? {
        let bundle = Bundle(for: FeedsViewController.self)
        let storyboard = UIStoryboard(name: "Feeds", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}
