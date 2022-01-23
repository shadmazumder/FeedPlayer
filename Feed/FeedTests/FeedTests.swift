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
        case resourceNotFound
    }
    
    private let uri: String
    private let client: Client
    
    public init(uri: String, client: Client){
        self.uri = uri
        self.client = client
    }
    
    func load(completion: @escaping ((Result<APIModel, LoaderError>) -> Void)){
        client.get(from: uri){ _ in
            completion(.failure(.resourceNotFound))
        }
    }
}

protocol Client {
    typealias Result = Swift.Result<Data, Error>
    func get(from uri: String, completion: @escaping (Result) -> Void)
}

class FeedClientSpy: Client {
    var message = [(uri: String, completion: (Result) -> Void)]()
    var requestedURI: [String] {
        message.map({ $0.uri })
    }
    
    func get(from uri: String, completion: @escaping (Client.Result) -> Void){
        message.append((uri, completion))
    }
    
    func completeWithError(_ error: Error, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}

class FeedTests: XCTestCase {
    func test_init_doesNotInitiateRequest() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURI.isEmpty)
    }
    
    func test_load_requestDataFromURI() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load() { _ in }
        XCTAssertTrue(client.requestedURI == [anyURI])
    }
    
    func test_loadTwice_requestDataFromURITwice() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load() { _ in }
        sut.load() { _ in }
        XCTAssertTrue(client.requestedURI == [anyURI, anyURI])
    }
    
    func test_load_deliverError_onClientError() {
        let (sut, client) = makeSUT()
        let anyError = NSError(domain: "Any doamin", code: 0)

        expect(sut, tocompleteWith: .failure(LocalLoader.Error.resourceNotFound)) {
            client.completeWithError(anyError)
        }
    }
    
    // MARK: - Helper
    private typealias LocalLoaderStringType = LocalLoader<String>
    
    private func makeSUT(_ uri: String = "") -> (sut: LocalLoaderStringType, client: FeedClientSpy){
        let client = FeedClientSpy()
        let sut = LocalLoaderStringType(uri: uri, client: client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
    
    private func expect(_ sut: LocalLoaderStringType, tocompleteWith expectedResult: LocalLoaderStringType.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for the client")

        sut.load { result in
            switch (result, expectedResult) {
            case let (.success(recieved), .success(expected)):
                XCTAssertEqual(recieved, expected, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError.localizedDescription, expectedError.localizedDescription, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult) but got \(result)", file: file, line: line)
            }
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
}
