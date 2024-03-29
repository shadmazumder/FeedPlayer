//
//  FeedClientSpy.swift
//  FeedTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import Foundation
import Feed

class FeedClientSpy: Client {
    var message = [(uri: String, completion: (Result) -> Void)]()
    var startingIndexCounter = [Int]()
    
    var requestedURI: [String] {
        message.map({ $0.uri })
    }
    
    func get(from uri: String, _ startingIndex: Int, completion: @escaping (Client.Result) -> Void){
        startingIndexCounter.append(startingIndex)
        message.append((uri, completion))
    }
    
    func completeWithError(_ error: Error, index: Int = 0) {
        message[index].completion(.failure(error))
    }
    
    func completeWith(_ data: Data, index: Int = 0) {
        message[index].completion(.success((data)))
    }
}
