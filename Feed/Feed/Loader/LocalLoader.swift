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
    
    public init(uri: String, client: Client){
        self.uri = uri
        self.client = client
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
            let root = try jsonDecoder.decode(FeedModelContainer.self, from: data)
            completion(.success(root))
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
