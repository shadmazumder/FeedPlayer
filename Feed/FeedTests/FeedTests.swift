//
//  LocalLoaderTests.swift
//  LocalLoaderTests
//
//  Created by Shad Mazumder on 23/1/22.
//

import XCTest
import Feed

class LocalLoaderTests: XCTestCase {
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
    
    func test_load_deliversEmptyItems_ForEmptyJSON() {
        let (sut, client) = makeSUT()
        let emptyEntities = ""

        expect(sut, tocompleteWith: .success("")) {
            let data = try! JSONEncoder().encode(emptyEntities)
            client.completeWith(data)
        }
    }
    
    func test_load_deliversItems_ForJSONItems() {
        let (sut, client) = makeSUT()
        let jsonWithData = anyValidJsonStringWithData()

        expect(sut, tocompleteWith: .success(jsonWithData.validJsonString)) {
            client.completeWith(jsonWithData.data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTBeenDeallocated() {
        let client = FeedClientSpy()
        var sut: LocalLoaderStringType? = LocalLoaderStringType(uri: anyURI, client: client)
        var receivedResult: LocalLoaderStringType.Result?
        sut?.load(completion: { receivedResult = $0 })

        sut = nil
        client.completeWith(anyValidJsonStringWithData().data)

        XCTAssertNil(receivedResult)
    }
    
    func test_load_deliverDecodingError_onFaultyKeyNameForJson() {
        typealias TitleFeedLocalLoader = LocalLoader<TitleFeed>
        
        struct TitleFeed: Decodable{
            let title: String
        }
        
        let validJsonString = "{\"name\":\"any title\"}"
        let jsonWithData = anyValidJsonStringWithData(validJsonString)
        
        let client = FeedClientSpy()
        let sut = TitleFeedLocalLoader(uri: anyURI, client: client)

        let exp = expectation(description: "Waiting for the client")
        
        sut.load { result in
            switch result {
            case let .failure(receivedError):
                if case TitleFeedLocalLoader.Error.decoding = receivedError {
                    exp.fulfill()
                }else{
                    fallthrough
                }
            default:
                XCTFail("Expected Failure but got \(result)")
            }
        }
        
        client.completeWith(jsonWithData.data)
        
        wait(for: [exp], timeout: 1.0)
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
    
    private func anyValidJsonStringWithData(_ validJsonString: String = "{\"title\":\"any title\"}") -> (validJsonString: String, data: Data) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(validJsonString)

        return (validJsonString, data)
    }
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
    
    func completeWith(_ data: Data, index: Int = 0) {
        message[index].completion(.success((data)))
    }
}
