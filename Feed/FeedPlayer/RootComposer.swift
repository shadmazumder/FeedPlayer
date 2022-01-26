//
//  RootComposer.swift
//  FeedPlayer
//
//  Created by Shad Mazumder on 26/1/22.
//

import UIKit

public struct RootComposer {
    public static var rootViewController: UIViewController{
        let jsonFeedPath = ResourcePaths.feedsJsonFile
        let logger = FeedLogger()
        return FeedsViewControllerComposer(jsonFeedFileName: jsonFeedPath, logger: logger).feedsViewController
    }
}
