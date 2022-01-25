//
//  FeedContainerMapper.swift
//  FeedTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import Foundation
import Feed

struct FeedContainerMapper: Encodable {
    let feeds: [FeedModelMapper]
}

extension FeedContainerMapper{
    var model: FeedModelContainer{ FeedModelContainer(feeds: feeds.mapToModel) }
}
