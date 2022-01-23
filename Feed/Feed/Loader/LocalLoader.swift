//
//  LocalLoader.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public class LocalLoader<T: Decodable>: Loader{
    public typealias APIModel = T
    public typealias LoaderError = Error
    
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
    
    public func load(completion: @escaping ((Result<APIModel, LoaderError>) -> Void)){
        client.get(from: uri){ [weak self] result in
            switch result {
            case let .success(data):
                self?.mapSuccessFrom(data, completion)
            default:
                completion(.failure(.resourceNotFound))
            }
        }
    }
    
    private func mapSuccessFrom(_ data: Data, _ completion: @escaping ((Result<APIModel, LoaderError>) -> Void)) {
        do {
            let jsonDecoder = JSONDecoder()
            let root = try jsonDecoder.decode(T.self, from: data)
            completion(.success(root))
        } catch {
            mapErrorFrom(error, completion)
        }
    }
    
    private func mapErrorFrom(_ error: Swift.Error, _ completion: ((Result<APIModel, LoaderError>) -> Void)) {
        if let decodingError = error as? DecodingError {
            completion(.failure(.decoding(decodingError)))
        }else {
            completion(.failure(.invalidData))
        }
    }
}
