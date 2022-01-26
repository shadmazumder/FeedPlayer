//
//  ErrorHandlerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest

import FeedPlayer

class ErrorHandlerTests: XCTestCase {
    func test_alertIsDelivers_onErrorState() {
        let viewController = ViewControllerSpy()
        viewController.loadViewIfNeeded()
        
        let feedErrorHandler = FeedErrorHandler(presentingViewController: viewController)
        
        feedErrorHandler.errorState = NSError(domain: "any-domain", code: 0)
        
        let presentingViewController = viewController.viewControllerToPresent
        XCTAssertTrue(presentingViewController is UIAlertController)
    }
}

private class ViewControllerSpy: UIViewController{
    var viewControllerToPresent: UIViewController? = nil
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
    }
}
