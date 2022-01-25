//
//  FeedModelMapper.swift
//  FeedTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import Foundation
import Feed

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
