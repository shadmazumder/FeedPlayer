//
//  FeedsViewController.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit
import Feed

public protocol FeedsViewControllerErrorDelegate {
    var errorState: Error? { get set }
}

public class FeedsViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    public var loader: Loader?
    public var errorHandler: FeedsViewControllerErrorDelegate?
    
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
        loader?.load(completion: { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                self.errorHandler?.errorState = failure
            }
        })
    }
}
