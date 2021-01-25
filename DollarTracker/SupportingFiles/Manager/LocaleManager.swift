//
//  LocaleManager.swift
//  DollarTracker
//
//  Created by SERDAR TURAN on 24.01.2021.
//

import Foundation

enum UserDefaultKeys: String {
    case apiKey
    case currencyTypes
    case displayMode
    case selectedCurrencyType
}

protocol LocaleManagerProtocol {
    func getApiKey() -> String?
    func getCurrencyTypes() -> [String : String]?
    func getDisplayMode() -> Int
    func getSelectedCurrencyType() -> String
    func setValue(value: Any?, key: UserDefaultKeys)
}

protocol UserDefaultsProtocol {
    func string(forKey defaultName: String) -> String?
    func integer(forKey defaultName: String) -> Int
    func dictionary(forKey defaultName: String) -> [String : Any]?
    func setValue(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol { }

class LocaleManager: LocaleManagerProtocol {
    
    var userDefaults: UserDefaultsProtocol = UserDefaults.standard
    
    func getApiKey() -> String? {
        return userDefaults.string(forKey: UserDefaultKeys.apiKey.rawValue)
    }
    
    func getCurrencyTypes() -> [String : String]? {
        guard let currenyTypes = userDefaults.dictionary(forKey: UserDefaultKeys.currencyTypes.rawValue) as? [String: String] else {
            return nil
        }
        return currenyTypes
    }

    func getDisplayMode() -> Int {
        return userDefaults.integer(forKey: UserDefaultKeys.displayMode.rawValue)
    }
    
    func getSelectedCurrencyType() -> String {
        return userDefaults.string(forKey: UserDefaultKeys.selectedCurrencyType.rawValue) ?? "EUR"
    }
    
    func setValue(value: Any?, key: UserDefaultKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
}
