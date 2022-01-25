//
//  FeedsViewController+TestHelper.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import UIKit
import FeediOS

extension FeedsViewController{
    private func indexPath(_ index: Int) -> IndexPath{
        IndexPath(row: index, section: 0)
    }
    func feedCell(_ index: Int = 0) -> FeedTableViewCell{
        dataSource.tableView(feedTableView, cellForRowAt: indexPath(index)) as! FeedTableViewCell
    }
    
    func cell(_ index: Int = 0) -> UITableViewCell{
        dataSource.tableView(feedTableView, cellForRowAt: indexPath(index))
    }
    
    func willDisplayCell(_ index: Int = 0){
        feedTableView.delegate?.tableView!(feedTableView, willDisplay: cell(index), forRowAt: indexPath(index))
    }
    
    func didEndDisplay(_ index: Int = 0){
        feedTableView.delegate?.tableView?(feedTableView, didEndDisplaying: cell(index), forRowAt: indexPath(index))
    }
    
    func prefetchRows(indices: [Int] ){
        let indexPaths = indices.map({ indexPath($0) })
        feedTableView.prefetchDataSource?.tableView(feedTableView, prefetchRowsAt: indexPaths)
    }
}
