//
//  FeedTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 23/1/22.
//

import XCTest

protocol FeedLoader {
    func load()
}

struct LocalFeedLoader: FeedLoader{
    private let uri: String
    private let client: FeedClient
    
    public init(uri: String, client: FeedClient){
        self.uri = uri
        self.client = client
    }
    
    func load(){
        client.get(from: uri)
    }
}

protocol FeedClient {
    func get(from uri: String)
}

class FeedClientSpy: FeedClient {
    var uri: String? = nil
    
    func get(from uri: String){
        self.uri = uri
    }
}

class FeedTests: XCTestCase {
    func test_init_doesNotInitiateRequest() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.uri)
    }
    
    func test_load_requestDataFromURI() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load()
        XCTAssertTrue(client.uri == anyURI)
    }
    
    // MARK: - Helper
    private func makeSUT(_ uri: String = "") -> (sut: LocalFeedLoader, client: FeedClientSpy){
        let client = FeedClientSpy()
        let sut = LocalFeedLoader(uri: uri, client: client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
}
