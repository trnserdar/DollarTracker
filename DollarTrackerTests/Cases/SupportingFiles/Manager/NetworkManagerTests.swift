//
//  NetworkManagerTests.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    var session: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
        session = MockURLSession()
        sut.urlSession = session
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    private func getCurrencyTypesData() -> Data {
        return """
            {
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
                "ALL": "Albanian Lek",
                "AMD": "Armenian Dram",
                "ANG": "Netherlands Antillean Guilder",
                "AOA": "Angolan Kwanza",
                "ARS": "Argentine Peso"
            }
            """.data(using: .utf8)!
    }
    
    private func getCurrencyTypesInvalidData() -> Data {
        return """
            {
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
                "ALL": "Albanian Lek",
                "AMD": "Armenian Dram",
                "ANG": "Netherlands Antillean Guilder",
                "AOA": "Angolan Kwanza"
                "ARS": 1
            }
            """.data(using: .utf8)!
    }
    
    private func getLatestData() -> Data {
        return """
            {
                "timestamp": 1611399603,
                "base": "USD",
                "rates": {
                    "AED": 3.673,
                    "AFN": 77.150005,
                    "ALL": 101.55,
                    "AMD": 520.561964
                }
            }
            """.data(using: .utf8)!
    }
    
    private func getLatestInvalidData() -> Data {
        return """
            {
                "timestamp": 1611399603,
                "base": "USD",
                "rates": {
                    "AED": 3.673,
                    "AFN": 77.150005,
                    "ALL": 101.55
                    "AMD": 520.561964
            }
            """.data(using: .utf8)!
    }
    
    func test_networkManager_conformsToNetworkManagerProtocol() {
        XCTAssertTrue((sut as AnyObject) is NetworkManagerProtocol)
    }
    
    func test_getCurrencyTypes_setDataTaskCount() {
        let expectationCurrencyTypes = expectation(description: "Currency Types")
        sut.getCurrencyTypes { (response) in
            expectationCurrencyTypes.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(nil, nil, nil)
        wait(for: [expectationCurrencyTypes], timeout: 0.1)
        XCTAssertEqual(session.dataTaskCallCount, 1)
    }
    
    func test_getCurrencyTypes_setURL() {
        let expectationCurrencyTypes = expectation(description: "Currency Types")
        sut.getCurrencyTypes { (response) in
            expectationCurrencyTypes.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(nil, nil, nil)
        wait(for: [expectationCurrencyTypes], timeout: 0.1)
        let url = URL(string: "\(NetworkConstants.baseURL)/currencies.json")!
        XCTAssertEqual(session.dataTaskArgsURLs.first, url)
    }
    
    func test_getCurrencyTypes_whenGivenValidJSON_setDictionary() {
        let expectationCurrencyTypes = expectation(description: "Currency Types")
        var dictionary: [String: String]? = [:]
        sut.getCurrencyTypes { (response) in
            dictionary = response
            expectationCurrencyTypes.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(getCurrencyTypesData(), nil, nil)
        wait(for: [expectationCurrencyTypes], timeout: 0.1)
        XCTAssertNotNil(dictionary)
    }
    
    func test_getCurrencyTypes_whenGivenInvalidJSON_setDictionary() {
        let expectationCurrencyTypes = expectation(description: "Currency Types")
        var dictionary: [String: String]? = [:]
        sut.getCurrencyTypes { (response) in
            dictionary = response
            expectationCurrencyTypes.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(getCurrencyTypesInvalidData(), nil, nil)
        wait(for: [expectationCurrencyTypes], timeout: 0.1)
        XCTAssertNil(dictionary)
    }

    func test_getLatest_setDataTaskCallCount() {
        let expectationLatest = expectation(description: "Latest")
        sut.getLatest(apiKey: "", selectedCurrency: "") { (response) in
            expectationLatest.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(nil, nil, nil)
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertEqual(session.dataTaskCallCount, 1)
    }
    
    func test_getLatest_setURL() {
        let expectationLatest = expectation(description: "Latest")
        sut.getLatest(apiKey: "testApiKey", selectedCurrency: "EUR") { (response) in
            expectationLatest.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(nil, nil, nil)
        wait(for: [expectationLatest], timeout: 0.1)
        let url = URL(string: "\(NetworkConstants.baseURL)/latest.json?app_id=testApiKey")
        XCTAssertEqual(session.dataTaskArgsURLs.first, url)
    }
    
    func test_getLatest_whenGivenInvalidURL_setDictionary() {
        let expectationLatest = expectation(description: "Latest")
        var dictionary: [String: Any]? = nil
        sut.getLatest(apiKey: "test Api Key", selectedCurrency: "AED") { (response) in
            dictionary = response
            expectationLatest.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(getLatestData(), nil, nil)
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertNil(dictionary)
    }
    
    func test_getLatest_whenGivenValidJSON_setDictionary() {
        let expectationLatest = expectation(description: "Latest")
        var dictionary: [String: Any]? = nil
        sut.getLatest(apiKey: "testApiKey", selectedCurrency: "AED") { (response) in
            dictionary = response
            expectationLatest.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(getLatestData(), nil, nil)
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertNotNil(dictionary)
    }
    
    func test_getLatest_whenGivenInvalidJSON_setDictionary() {
        let expectationLatest = expectation(description: "Latest")
        var dictionary: [String: Any]? = nil
        sut.getLatest(apiKey: "testApiKey", selectedCurrency: "EUR") { (response) in
            dictionary = response
            expectationLatest.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(getLatestInvalidData(), nil, nil)
        wait(for: [expectationLatest], timeout: 0.1)
        XCTAssertNil(dictionary)
    }
    
}
