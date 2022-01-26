//
//  FeedsViewController.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit
import Feed

public protocol FeedsViewControllerErrorDelegate: AnyObject {
    var errorState: Error? { get set }
}

public class FeedsViewController: UIViewController {
    @IBOutlet weak public private(set) var feedTableView: UITableView!
    public var playerDelegate: PlayerDelegate?
    
    public var loader: Loader?
    public weak var errorHandler: FeedsViewControllerErrorDelegate?
  
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, FeedViewModel> = {
        .init(tableView: feedTableView) { [weak self] (_, _, feed) in
            self?.configuredFeedCell(for: feed)
        }
    }()
    
    private func configuredFeedCell(for feed: FeedViewModel) -> UITableViewCell{
        let feedCell: FeedTableViewCell = feedTableView.dequeueReusableCell()
        feedCell.configure(with: feed)
        return feedCell
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadFeeds(startingIndex: 0)
    }
    
    private func configureTableView(){
        dataSource.defaultRowAnimation = .automatic
        feedTableView.dataSource = dataSource
        feedTableView.delegate = self
        feedTableView.prefetchDataSource = self
    }
    
    private func loadFeeds(startingIndex: Int){
        loader?.load(from: startingIndex, completion: { [weak self] result in
            switch result {
            case let .success(feedContainer):
                self?.diffarableReload(with: feedContainer.feedViewModel)
            case .failure(let failure):
                self?.errorHandler?.errorState = failure
            }
        })
    }
    
    func loadNextFeeds(){
        loadFeeds(startingIndex: dataSource.snapshot().numberOfItems)
    }
    
    private func diffarableReload(with latestFeeds: [FeedViewModel]){
        let existingFeeds = dataSource.snapshot().itemIdentifiers
        let totalFeeds = existingFeeds + latestFeeds
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(totalFeeds)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
