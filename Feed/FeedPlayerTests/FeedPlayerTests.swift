//
//  FeedPlayerTests.swift
//  FeedPlayerTests
//
//  Created by Shad Mazumder on 26/1/22.
//

import XCTest
import FeediOS
import FeedPlayer

class FeedPlayerTests: XCTestCase {
    func test_deliversMessage_onLogMessage() {
        let anyMesssage = "Any message"
        let logger = LoggerSpy()
        let sut = FeedPlayer(feedLogger: logger)
        
        sut.logMessage(anyMesssage)
        
        XCTAssertEqual(logger.message, anyMesssage)
    }
}

private class LoggerSpy: Logger{
    var message: String?
    
    func logMessage(_ message: String?) {
        self.message = message
    }
}
