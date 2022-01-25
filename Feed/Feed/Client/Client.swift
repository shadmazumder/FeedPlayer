//
//  Client.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public protocol Client {
    typealias Result = Swift.Result<Data, Error>
    func get(from uri: String, _ startingIndex: Int, completion: @escaping (Result) -> Void)
}
