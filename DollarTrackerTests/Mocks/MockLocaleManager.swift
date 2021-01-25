//
//  MockLocaleManager.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class MockLocaleManager: LocaleManagerProtocol {

    var dictString: [String: String] = [:]
    var dictInt: [String: Int] = [:]
    var dictDictionary: [String: [String: String]] = [:]
    
    func getApiKey() -> String? {
        return dictString[UserDefaultKeys.apiKey.rawValue]
    }
    
    func getCurrencyTypes() -> [String : String]? {
        return dictDictionary[UserDefaultKeys.currencyTypes.rawValue]
    }
    
    func getDisplayMode() -> Int {
        return dictInt[UserDefaultKeys.displayMode.rawValue] ?? 0
    }
    
    func getSelectedCurrencyType() -> String {
        return dictString[UserDefaultKeys.selectedCurrencyType.rawValue] ?? "EUR"
    }
    
    func setValue(value: Any?, key: UserDefaultKeys) {
        if let valueAsString = value as? String {
            dictString[key.rawValue] = valueAsString
        }
        
        if let valueAsInt = value as? Int {
            dictInt[key.rawValue] = valueAsInt
        }
        
        if let valueAsDictionaries = value as? [String: String] {
            dictDictionary[key.rawValue] = valueAsDictionaries
        }
    }

}
