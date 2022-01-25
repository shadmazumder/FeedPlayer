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
        let root = FeedContainerMapper(feeds: [FeedModelMapper]())

        expect(sut, tocompleteWith: .success(root.model)) {
            let data = try! JSONEncoder().encode(root)
            client.completeWith(data)
        }
    }
    
    func test_load_deliversItems_ForJSONItems() {
        let (sut, client) = makeSUT()
        let feedContainerWithData = anyFeedContainerWithData([anyFeedMapper])

        expect(sut, tocompleteWith: .success(feedContainerWithData.feedContainerMapper.model)) {
            client.completeWith(feedContainerWithData.data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTBeenDeallocated() {
        let client = FeedClientSpy()
        var sut: LocalLoader? = LocalLoader(uri: anyURI, client: client)
        var receivedResult: LocalLoader.Result?
        sut?.load(completion: { receivedResult = $0 })

        sut = nil
        client.completeWith(anyFeedContainerWithData([anyFeedMapper]).data)

        XCTAssertNil(receivedResult)
    }
    
    func test_load_deliverDecodingError_onFaultyKeyNameForJson() {
        let emptyEntities = ""

        let client = FeedClientSpy()
        let sut = LocalLoader(uri: anyURI, client: client)

        let exp = expectation(description: "Waiting for the client")

        sut.load { result in
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
        let sut = LocalLoader(uri: uri, client: client)
        return (sut, client)
    }
    
    private let anyURI = "any-uri"
    
    private func expect(_ sut: LocalLoader, tocompleteWith expectedResult: Loader.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for the client")

        sut.load { result in
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
    
    private func anyFeedContainerWithData(_ feedMappers: [FeedModelMapper]) -> (feedContainerMapper: FeedContainerMapper, data: Data) {
        let feedContainer = FeedContainerMapper(feeds: feedMappers)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(feedContainer)

        return (feedContainer, data)
    }
    
    private var anyFeedMapper: FeedModelMapper{
        FeedModelMapper(title: "any title", description: "any description", source: "any-source")
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

struct FeedModelMapper: Equatable, Encodable {
    let title: String
    let description: String
    let source: String
}

extension FeedModelMapper{
    var model: FeedModel{
        FeedModel(title: title, description: description, source: source)
    }
}

extension FeedModel{
    var mapper: FeedModelMapper{
        FeedModelMapper(title: title, description: description, source: source)
    }
}

extension Array where Element == FeedModelMapper{
    var mapToModel: [FeedModel]{ map({ $0.model }) }
}

extension Array where Element == FeedModel{
    var mapToMapper: [FeedModelMapper]{ map({ $0.mapper }) }
}
