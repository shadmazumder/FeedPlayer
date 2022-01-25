//
//  LocalClient.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public struct LocalClient: Client {
    enum Error: Swift.Error {
        case corruptedData
    }
    
    public func get(from uri: String, _ startingIndex: Int, completion: @escaping (Client.Result) -> Void) {
        do{
            // Here we will load next feeds based on the startingIndex
            completion(.success(try Data(contentsOf: URL(fileURLWithPath: uri))))
        }catch {
            completion(.failure(Error.corruptedData))
        }
    }
}
