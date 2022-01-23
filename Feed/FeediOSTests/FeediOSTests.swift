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
    
    func test_init_rendersNothing() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue((sut.dataSource.snapshot().numberOfItems == 0))
    }
    
    // MARK: - Helper
    private func makeSUT() -> FeedsViewController{
         launchesViewControllerFromFeedsSotyboard() as! FeedsViewController
    }
    
    private func launchesViewControllerFromFeedsSotyboard() -> UIViewController? {
        let bundle = Bundle(for: FeedsViewController.self)
        let storyboard = UIStoryboard(name: "Feeds", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}
