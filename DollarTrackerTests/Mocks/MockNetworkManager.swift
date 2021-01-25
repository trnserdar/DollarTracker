//
//  MockNetworkManager.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class MockNetworkManager: NetworkManagerProtocol {

    var currencyTypesCount = 0
    var currencyTypesCompletion: (([String: String]?) -> Void)!
    
    var latestCount = 0
    var latestCompletion: (([String: Any]?) -> Void)!
    
    func getCurrencyTypes(completion: @escaping ([String : String]?) -> Void) {
        currencyTypesCount += 1
        currencyTypesCompletion = completion
    }
    
    func getLatest(apiKey: String, selectedCurrency: String, completion: @escaping ([String : Any]?) -> Void) {
        latestCount += 1
        latestCompletion = completion
    }

}
