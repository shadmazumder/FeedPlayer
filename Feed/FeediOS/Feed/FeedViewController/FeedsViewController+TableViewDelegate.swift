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
}
