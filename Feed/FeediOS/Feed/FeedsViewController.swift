//
//  FeedsViewController.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit
import Feed

public class FeedsViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    public var loader: Loader?
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, FeedViewModel> = {
        .init(tableView: feedTableView) { [weak self] (_, _, feed) in
            self?.configuredFeedCell(for: feed)
        }
    }()
    
    private func configuredFeedCell(for feed: FeedViewModel) -> UITableViewCell{
        return UITableViewCell()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadFeeds()
    }
    
    private func loadFeeds(){
        loader?.load(completion: { _ in })
    }
}
