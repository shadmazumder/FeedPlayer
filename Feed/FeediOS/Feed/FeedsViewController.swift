//
//  FeedsViewController.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit

public class FeedsViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    
    public private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, FeedViewModel> = {
        .init(tableView: feedTableView) { [weak self] (_, _, feed) in
            self?.configuredFeedCell(for: feed)
        }
    }()
    
    private func configuredFeedCell(for feed: FeedViewModel) -> UITableViewCell{
        return UITableViewCell()
    }
}
