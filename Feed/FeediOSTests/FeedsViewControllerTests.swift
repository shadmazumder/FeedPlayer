//
//  FeedsViewControllerTests.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 24/1/22.
//

import XCTest
import Feed
import FeediOS

class FeedsViewControllerTests: XCTestCase {
    func test_loadFromStoryboard_returnsFeedViewController() {
        XCTAssertTrue(launchesViewControllerFromFeedsSotyboard() is FeedsViewController, "Initial ViewController is not FeedsViewController")
    }
    
    func test_init_rendersNothing() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue((sut.dataSource.snapshot().numberOfItems == 0))
    }
    
    func test_load_initiateFeedRequest() {
        let anyURI = XCTestCase.anyURI
        let (sut, client) = makeSUT(uri: anyURI)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(client.message[0].uri, anyURI)
    }
    
    func test_onClientError_deliversError() {
        let exp = expectation(description: "Waiting for the client")
        let errorHandler = FeedsErrorHandler(exp)
        let notFoundError = LocalLoader.Error.resourceNotFound
        
        let (sut, client) = makeSUT()
        sut.errorHandler = errorHandler
        
        sut.loadViewIfNeeded()
        
        client.completeWithError(notFoundError)
        
        XCTAssertTrue(errorHandler.errorState is LocalLoader.Error)
        
        
        wait(for: [exp], timeout: 0.1)
        
    }
    
    func test_rendersCell_onValidFeeds() {
        let sut = renderedSUT(with: [anyFeedMapper])
        
        XCTAssertNotNil(sut.cell())
    }
    
    func test_load_requestNoPagination() {
        let (_, client) = completedWithSuccess()
        XCTAssertEqual(client.startingIndexCounter.count, 1)
    }
    
    func test_prefetchRows_requestForNextFeeds() {
        let (sut, client) = completedWithSuccess()
        
        let indicies = [8,9,10]
        indicies.forEach({ sut.prefetchRows(indices: [$0]) })
        
        XCTAssertEqual(client.startingIndexCounter.count, indicies.count + 1)
    }
    
    private func completedWithSuccess() -> (sut: FeedsViewController, client:FeedClientSpy){
        let (sut, client) = makeSUT()
        sut.loadViewIfNeeded()
        
        let feedContainerData = anyFeedContainerWithData([anyFeedMapper])
        client.completeWith(feedContainerData.data)
        
        return (sut, client)
    }
    
    func test_noRetainCycle_btweenViewControllerAndErrorHandler() {
        let (sut, _) = makeSUT()
        var feedErrorHandler: FeedsErrorHandler? = FeedsErrorHandler()
        sut.errorHandler = feedErrorHandler
        feedErrorHandler?.errorState = NSError(domain: "any-domain", code: 0)
        
        feedErrorHandler = nil
        
        XCTAssertNil(sut.errorHandler)
    }
}

private class FeedsErrorHandler: FeedsViewControllerErrorDelegate{
    let exp: XCTestExpectation?
    
    init(_ exp: XCTestExpectation? = nil) {
        self.exp = exp
    }
    
    var errorState: Error?{
        didSet{
            exp?.fulfill()
        }
    }
}
