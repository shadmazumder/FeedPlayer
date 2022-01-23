//
//  LocalClientTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 24/1/22.
//

import XCTest
import Feed

struct LocalClient: Client {
    func get(from uri: String, completion: @escaping (Client.Result) -> Void) {
        
    }
}

class LocalClientTests: XCTestCase {
    func test_init_doesNotPerformCompletion() {
        var completionCalled = false
        let sut = LocalClient()
        
        sut.get(from: anyUri) { _ in
            completionCalled = true
        }
        
        XCTAssertFalse(completionCalled)
    }
    
    // MARK: - Helper
    private let anyUri = "any-uri"
}
