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
        sut.load(from: 0) { _ in }
        XCTAssertTrue(client.requestedURI == [anyURI])
    }
    
    func test_loadTwice_requestDataFromURITwice() {
        let anyURI = anyURI
        let (sut, client) = makeSUT(anyURI)
        sut.load(from: 0) { _ in }
        sut.load(from: 0) { _ in }
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
        let root = FeedContainerMapper(feeds: [FeedModelMapper]())

        expect(sut, tocompleteWith: .success(root.model)) {
            let data = try! JSONEncoder().encode(root)
            client.completeWith(data)
        }
    }
    
    func test_load_deliversItems_ForJSONItems() {
        let client = FeedClientSpy()
        let sut = LocalLoader(uri: anyURI, client: client, feedGenerator: NonUniqueFeedGenerator())
        
        let feedContainerWithData = anyFeedContainerWithData([anyFeedMapper])

        expect(sut, tocompleteWith: .success(feedContainerWithData.feedContainerMapper.model)) {
            client.completeWith(feedContainerWithData.data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTBeenDeallocated() {
        let client = FeedClientSpy()
        var sut: LocalLoader? = LocalLoader(uri: anyURI, client: client, feedGenerator: feedGenerator)
        var receivedResult: LocalLoader.Result?
        sut?.load(from: 0, completion: { receivedResult = $0 })

        sut = nil
        client.completeWith(anyFeedContainerWithData([anyFeedMapper]).data)

        XCTAssertNil(receivedResult)
    }
    
    func test_load_deliverDecodingError_onFaultyKeyNameForJson() {
        let emptyEntities = ""

        let client = FeedClientSpy()
        let sut = LocalLoader(uri: anyURI, client: client, feedGenerator: feedGenerator)

        let exp = expectation(description: "Waiting for the client")

        sut.load(from: 0) { result in
            switch result {
            case let .failure(receivedError):
                if case LocalLoader.Error.decoding = receivedError {
                    exp.fulfill()
                }else{
                    fallthrough
                }
            default:
                XCTFail("Expected Failure but got \(result)")
            }
        }

        client.completeWith(Data(emptyEntities.utf8))

        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helper
    private func makeSUT(_ uri: String = "") -> (sut: LocalLoader, client: FeedClientSpy){
        let client = FeedClientSpy()
        let sut = LocalLoader(uri: uri, client: client, feedGenerator: feedGenerator)
        trackMemoryLeak(sut)
        trackMemoryLeak(client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
    private let feedGenerator = FeedGenerator()
    
    private func expect(_ sut: LocalLoader, tocompleteWith expectedResult: Loader.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for the client")

        sut.load(from: 0) { result in
            switch (result, expectedResult) {
            case let (.success(recieved), .success(expected)):
                XCTAssertEqual(recieved.feeds.mapToMapper, expected.feeds.mapToMapper, file: file, line: line)
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
