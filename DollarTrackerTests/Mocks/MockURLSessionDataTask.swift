//
//  MockURLSessionDataTask.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import Foundation
import XCTest
@testable import DollarTracker

class MockURLSessionDataTask: URLSessionDataTask {
    
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, url: URL) {
        self.completionHandler = completionHandler
        self.url = url
        super.init()
    }
    
    var calledResume = false
    override func resume() {
        calledResume = true
    }
}
