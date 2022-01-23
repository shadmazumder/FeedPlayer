//
//  LocalClientTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 24/1/22.
//

import XCTest
import Feed

struct LocalClient: Client {
    enum Error: Swift.Error {
        case invalidURI
    }
    
    func get(from uri: String, completion: @escaping (Client.Result) -> Void) {
        completion(.failure(Error.invalidURI))
    }
}

class LocalClientTests: XCTestCase {
    func test_get_executesCompletion() {
        var completionCalled = false
        let sut = LocalClient()
        
        sut.get(from: anyUri) { _ in
            completionCalled = true
        }
        
        XCTAssertTrue(completionCalled)
    }
    
    // MARK: - Helper
    private let anyUri = "any-uri"
}
