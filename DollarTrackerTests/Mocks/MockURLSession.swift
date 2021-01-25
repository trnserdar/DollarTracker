//
//  MockURLSession.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import Foundation
import XCTest
@testable import DollarTracker

class MockURLSession: URLSessionProtocol {
   
    var dataTaskCallCount = 0
    var dataTaskArgsURLs: [URL] = []
    var dataTaskArgsCompletionHandler: [(Data?, URLResponse?, Error?) -> Void] = []

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsURLs.append(url)
        dataTaskArgsCompletionHandler.append(completionHandler)
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url)
    }
}

