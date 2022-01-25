//
//  FeedViewModel.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation
import Feed

public struct FeedViewModel: Hashable {
    let title: String
    let description: String
    let source: String
}

extension FeedModel{
    var viewModel: FeedViewModel{
        FeedViewModel(title: title, description: description, source: source)
    }
}

extension Array where Element == FeedModel{
    var viewModels: [FeedViewModel]{ map({ $0.viewModel }) }
}


extension FeedModelContainer{
    var feedViewModel: [FeedViewModel]{ feeds.viewModels }
}
