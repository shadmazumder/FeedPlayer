//
//  UITableView+DequeCell.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
