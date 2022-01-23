//
//  FeedTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 23/1/22.
//

import XCTest

protocol Loader {
    func load()
}

struct LocalLoader: Loader{
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
    var uri = [String]()
    
    func get(from uri: String){
        self.uri.append(uri)
    }
}

class FeedTests: XCTestCase {
    func test_init_doesNotInitiateRequest() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.uri.isEmpty)
    }
    
    func test_load_requestDataFromURI() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load()
        XCTAssertTrue(client.uri == [anyURI])
    }
    
    func test_loadTwice_requestDataFromURITwice() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load()
        sut.load()
        XCTAssertTrue(client.uri == [anyURI, anyURI])
    }
    
//    func test_load_deliversError_onClientError() {
//
//    }
    
    // MARK: - Helper
    private func makeSUT(_ uri: String = "") -> (sut: LocalLoader, client: FeedClientSpy){
        let client = FeedClientSpy()
        let sut = LocalLoader(uri: uri, client: client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
}
