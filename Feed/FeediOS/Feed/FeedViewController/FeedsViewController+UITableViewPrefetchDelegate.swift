//
//  FeedsViewController+UITableViewPrefetchDelegate.swift
//  FeediOS
//
//  Created by Shad Mazumder on 25/1/22.
//

import UIKit

extension FeedsViewController: UITableViewDataSourcePrefetching{
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if shouldLoadNext(indexPaths) {
            loadNextFeeds()
        }
    }
    
    private func shouldLoadNext(_ indexPaths: [IndexPath]) -> Bool{
        guard let maxIndex = indexPaths.map({ $0.row }).max() else {return false}
        let totalItems = dataSource.snapshot().numberOfItems
        return maxIndex > totalItems - 5
    }
}
