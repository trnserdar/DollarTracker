//
//  AppDelegateTests.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 23.01.2021.
//

import XCTest
@testable import DollarTracker

class AppDelegateTests: XCTestCase {

    var sut: AppDelegate!
    var localeManager: MockLocaleManager!
    var networkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = AppDelegate()
        networkManager = MockNetworkManager()
        sut.networkManager = networkManager
        localeManager = MockLocaleManager()
        sut.localeManager = localeManager
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        networkManager = nil
        localeManager = nil
        super.tearDown()
    }
    
    func test_initAppDelegate_setStatusItemTitle() {
        XCTAssertEqual(sut.statusItem?.button?.title, "Dollar Tracker")
    }
    
    func test_getLatest_whenApiKeyEmpty_setStatusItemTitle() {
        localeManager.setValue(value: nil, key: .apiKey)
        sut.getLatest()
        XCTAssertEqual(sut.statusItem?.button?.title, "Please enter api key")
    }

    func test_getLatest_whenResponseEmpty_setStatusItemTitle() {
        let expectationLatest = expectation(description: "Latest")
        localeManager.setValue(value: "test", key: .apiKey)
        sut.getLatest()
        networkManager.latestCompletion?(nil)
        DispatchQueue.main.async {
            expectationLatest.fulfill()
        }
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertEqual(sut.statusItem?.button?.title, "Please enter valid api key")
    }
    
    func test_getLatest_whenGivenResponse_whenDisplayOption0_setStatusItemTitle() {
        let expectationLatest = expectation(description: "Latest")
        localeManager.setValue(value: "test", key: .apiKey)
        localeManager.setValue(value: "EUR", key: .selectedCurrencyType)
        sut.getLatest()
        networkManager.latestCompletion?(["timestamp": 1611399603, "EUR": 0.821389])
        DispatchQueue.main.async {
            expectationLatest.fulfill()
        }
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertEqual(sut.statusItem?.button?.title, "1 USD = 0.82 EUR 14:00")
    }
    
    func test_getLatest_whenGivenResponse_whenDisplayOption1_setStatusItemTitle() {
        let expectationLatest = expectation(description: "Latest")
        localeManager.setValue(value: "test", key: .apiKey)
        localeManager.setValue(value: "EUR", key: .selectedCurrencyType)
        localeManager.setValue(value: 1, key: .displayMode)
        sut.getLatest()
        networkManager.latestCompletion?(["timestamp": 1611399603, "EUR": 0.821389])
        DispatchQueue.main.async {
            expectationLatest.fulfill()
        }
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertEqual(sut.statusItem?.button?.title, "1 EUR = 1.22 USD 14:00")
    }
}
