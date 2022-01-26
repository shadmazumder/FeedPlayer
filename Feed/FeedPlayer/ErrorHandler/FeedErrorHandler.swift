//
//  FeedErrorHandler.swift
//  FeedPlayer
//
//  Created by Shad Mazumder on 26/1/22.
//

import UIKit
import FeediOS

public class FeedErrorHandler: FeedsViewControllerErrorDelegate {
    private weak var presentingViewController: UIViewController?
    
    public init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    public var errorState: Error?{
        didSet{
            let alert = UIAlertController(title: "Oops!!!", message: "Sorry, we messed up!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            presentingViewController?.present(alert, animated: true)
        }
    }
}
