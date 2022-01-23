//
//  FeedTests.swift
//  FeedTests
//
//  Created by Shad Mazumder on 23/1/22.
//

import XCTest

protocol Loader {
    associatedtype APIModel: Decodable
    associatedtype LoaderError: Error
    
    typealias Result = Swift.Result<APIModel, LoaderError>

    func load(completion: @escaping ((Result) -> Void))
}

struct LocalLoader<T: Decodable>: Loader{
    public typealias APIModel = T
    public typealias LoaderError = Error
    
    public enum Error: Swift.Error {
    }
    
    private let uri: String
    private let client: Client
    
    public init(uri: String, client: Client){
        self.uri = uri
        self.client = client
    }
    
    func load(completion: @escaping ((Result<APIModel, LoaderError>) -> Void)){
        client.get(from: uri)
    }
}

protocol Client {
    func get(from uri: String)
}

class FeedClientSpy: Client {
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
        sut.load() { _ in }
        XCTAssertTrue(client.uri == [anyURI])
    }
    
    func test_loadTwice_requestDataFromURITwice() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load() { _ in }
        sut.load() { _ in }
        XCTAssertTrue(client.uri == [anyURI, anyURI])
    }
    
    // MARK: - Helper
    private typealias RemoteLoaderStringType = LocalLoader<String>
    
    private func makeSUT(_ uri: String = "") -> (sut: RemoteLoaderStringType, client: FeedClientSpy){
        let client = FeedClientSpy()
        let sut = RemoteLoaderStringType(uri: uri, client: client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
}
