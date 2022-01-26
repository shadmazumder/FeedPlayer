//
//  FeedsViewControllerComposer.swift
//  FeedPlayer
//
//  Created by Shad Mazumder on 26/1/22.
//

import UIKit
import Feed
import FeediOS

public class FeedsViewControllerComposer{
    private let jsonFeedFileName: String
    private let logger: Logger
    
    public init(jsonFeedFileName: String, logger: Logger) {
        self.jsonFeedFileName = jsonFeedFileName
        self.logger = logger
    }
    
    public var feedsViewController: FeedsViewController{
        let feedsViewController = feedStoryboard.instantiateInitialViewController() as! FeedsViewController
        defer{ configure(feedsViewController) }
        return feedsViewController
    }
    
    private let feedStoryboard: UIStoryboard = {
        let bundle = Bundle(for: FeedsViewController.self)
        return UIStoryboard(name: "Feeds", bundle: bundle)
    }()
    
    private func configure(_ feedsViewController: FeedsViewController){
        feedsViewController.playerDelegate = FeedPlayer(feedLogger: logger)
        feedsViewController.errorHandler = FeedErrorHandler(presentingViewController: feedsViewController)
        configureLocalLoader(for: feedsViewController, logErrorOn: logger)
    }
    
    private func configureLocalLoader(for feedsViewController: FeedsViewController, logErrorOn logger: Logger){
        let failableLoader = makeFailableLocalLoader()
        if let loader = failableLoader.localLoader {
            feedsViewController.loader = loader
        }else{
            logger.logMessage(failableLoader.errorMessage)
        }
    }
    
    private func makeFailableLocalLoader() -> (localLoader: LocalLoader?, errorMessage: String?){
        let allJsonPaths = Bundle.main.paths(forResourcesOfType: ".json", inDirectory: nil)
        
        guard let path = allJsonPaths.filter({ $0.contains(jsonFeedFileName) }).first else {
            return (nil, "Json file was not found on the path")
        }
        let localLoader = LocalLoader(uri: path, client: LocalClient(), feedGenerator: FeedGenerator())
        return (localLoader, nil)
    }
}
