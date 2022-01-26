//
//  RootComposerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest
import FeedPlayer
@testable import FeediOS

class RootComposerTests: XCTestCase {
    func test_feedsViewController_asRootViewController() {
        XCTAssertTrue(RootComposer.rootViewController is FeedsViewController)
    }
}
