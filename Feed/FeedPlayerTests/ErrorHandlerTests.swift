//
//  ErrorHandlerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest
import FeediOS

class FeedErrorHandler: FeedsViewControllerErrorDelegate {
    private weak var presentingViewController: UIViewController?
    
    var errorState: Error?{
        didSet{
            let alert = UIAlertController(title: "Oops!!!", message: "Sorry, we messed up!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            presentingViewController?.present(alert, animated: true)
        }
    }
}

class ErrorHandlerTests: XCTestCase {
}
