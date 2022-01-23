//
//  FeedTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 23/1/22.
//

import XCTest

protocol FeedLoader {
    
}

struct LocalFeedLoader: FeedLoader{}

protocol FeedClient {
    
}

struct FeedClientSpy: FeedClient {
    var counter = 0
}

class FeedTests: XCTestCase {
    func test_init_doesNotInitiateRequest() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.counter == 0)
    }
    
    // MARK: - Helper
    private func makeSUT() -> (sut: FeedLoader, client: FeedClientSpy){
        return (LocalFeedLoader(), FeedClientSpy())
    }
}
