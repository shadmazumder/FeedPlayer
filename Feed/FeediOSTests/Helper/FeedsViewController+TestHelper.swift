//
//  FeedsViewController+TestHelper.swift
//  FeediOSTests
//
//  Created by Shad Mazumder on 25/1/22.
//

import UIKit
import FeediOS

extension FeedsViewController{
    func feedCell(_ index: Int = 0) -> FeedTableViewCell{
        dataSource.tableView(feedTableView, cellForRowAt: IndexPath(row: index, section: 0)) as! FeedTableViewCell
    }
    
    func cell(_ index: Int = 0) -> UITableViewCell{
        dataSource.tableView(feedTableView, cellForRowAt: IndexPath(row: index, section: 0))
    }
}
