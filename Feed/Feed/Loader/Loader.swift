//
//  Loader.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public protocol Loader {
    typealias Result = Swift.Result<FeedModelContainer, Error>

    func load(completion: @escaping ((Result) -> Void))
}
