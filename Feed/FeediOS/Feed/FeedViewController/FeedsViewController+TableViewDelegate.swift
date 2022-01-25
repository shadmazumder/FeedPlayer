//
//  FeedsViewController+TableViewDelegate.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit

extension FeedsViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.size.height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let feed = dataSource.itemIdentifier(for: indexPath)
        let feedCell = (cell as? FeedTableViewCell)
        feedCell?.play(on: playerDelegate?.player, for: feed?.source, logger: playerDelegate)
    }
}
