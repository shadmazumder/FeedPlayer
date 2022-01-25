//
//  FeediOSTests.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 24/1/22.
//

import XCTest
import Feed
import FeediOS

class FeediOSTests: XCTestCase {
    func test_loadFromStoryboard_returnsFeedViewController() {
        XCTAssertTrue(launchesViewControllerFromFeedsSotyboard() is FeedsViewController, "Initial ViewController is not FeedsViewController")
    }
    
    func test_init_rendersNothing() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertTrue((sut.dataSource.snapshot().numberOfItems == 0))
    }
    
    func test_load_initiateFeedRequest() {
        let anyURI = FeediOSTests.anyURI
        let (sut, client) = makeSUT(uri: anyURI)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(client.message[0].uri, anyURI)
    }
    
    func test_onClientError_deliversError() {
        let exp = expectation(description: "Waiting for the client")
        let errorHandler = FeedsErrorHandler(exp: exp)
        let notFoundError = LocalLoader.Error.resourceNotFound
        
        let (sut, client) = makeSUT()
        sut.errorHandler = errorHandler
        
        sut.loadViewIfNeeded()
        
        client.completeWithError(notFoundError)
        
        XCTAssertTrue(errorHandler.errorState is LocalLoader.Error)
        
        
        wait(for: [exp], timeout: 0.1)
        
    }
    
    func test_rendersCell_onValidFeeds() {
        let feedContainerData = FeedMapperProvider.anyFeedContainerWithData([FeedMapperProvider.anyFeedMapper])
        let (sut, client) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        client.completeWith(feedContainerData.data)
        
        XCTAssertNotNil(sut.cell())
    }
    
    // MARK: - Helper
    private func makeSUT(uri: String = FeediOSTests.anyURI) -> (sut: FeedsViewController, client: FeedClientSpy){
        let clientSpy = FeedClientSpy()
        let sut = launchesViewControllerFromFeedsSotyboard() as! FeedsViewController
        sut.loader = LocalLoader(uri: uri, client: clientSpy)
        
        return (sut, clientSpy)
    }
    
    private func launchesViewControllerFromFeedsSotyboard() -> UIViewController? {
        let bundle = Bundle(for: FeedsViewController.self)
        let storyboard = UIStoryboard(name: "Feeds", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
    
    private static var anyURI: String { "any-uri" }
}

private class FeedsErrorHandler: FeedsViewControllerErrorDelegate{
    let exp: XCTestExpectation
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    
    var errorState: Error?{
        didSet{
            exp.fulfill()
        }
    }
}

extension FeedsViewController{
    func cell(_ index: Int = 0) -> UITableViewCell{
        dataSource.tableView(feedTableView, cellForRowAt: IndexPath(row: index, section: 0))
    }
}
