//
//  XCTestCase+Helper.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import XCTest
import Feed
import FeediOS

extension XCTestCase{
    func makeSUT(uri: String = FeediOSTests.anyURI) -> (sut: FeedsViewController, client: FeedClientSpy){
        let clientSpy = FeedClientSpy()
        let sut = launchesViewControllerFromFeedsSotyboard() as! FeedsViewController
        sut.loader = LocalLoader(uri: uri, client: clientSpy)
        
        return (sut, clientSpy)
    }
    
    func launchesViewControllerFromFeedsSotyboard() -> UIViewController? {
        let bundle = Bundle(for: FeedsViewController.self)
        let storyboard = UIStoryboard(name: "Feeds", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
    
    static var anyURI: String { "any-uri" }
}
