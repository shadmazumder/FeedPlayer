//
//  LocalLoader.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public class LocalLoader: Loader{
    public enum Error: Swift.Error {
        case resourceNotFound
        case invalidData
        case decoding(DecodingError)
    }
    
    private let uri: String
    private let client: Client
    private let feedGenerator: UniqueFeedGenerator
    
    public init(uri: String, client: Client, feedGenerator: UniqueFeedGenerator){
        self.uri = uri
        self.client = client
        self.feedGenerator = feedGenerator
    }
    
    public func load(from startingIndex: Int, completion: @escaping ((Loader.Result) -> Void)) {
        client.get(from: uri, startingIndex){ [weak self] result in
            switch result {
            case let .success(data):
                self?.mapSuccessFrom(data, completion)
            default:
                completion(.failure(Error.resourceNotFound))
            }
        }
    }
    
    private func mapSuccessFrom(_ data: Data, _ completion: @escaping ((Loader.Result) -> Void)) {
        do {
            let jsonDecoder = JSONDecoder()
            let container = try jsonDecoder.decode(FeedModelContainer.self, from: data)
            let uniqueFeeds = feedGenerator.generateUnique(container.feeds)
            let uniqueFeedContainer = FeedModelContainer(feeds: uniqueFeeds)
            completion(.success(uniqueFeedContainer))
        } catch {
            mapErrorFrom(error, completion)
        }
    }
    
    private func mapErrorFrom(_ error: Swift.Error, _ completion: ((Loader.Result) -> Void)) {
        if let decodingError = error as? DecodingError {
            completion(.failure(Error.decoding(decodingError)))
        }else {
            completion(.failure(Error.invalidData))
        }
    }
}
