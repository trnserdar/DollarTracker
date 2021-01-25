//
//  FakeUserDefaults.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class FakeUserDefaults: UserDefaultsProtocol {
    
    var dictString: [String: String] = [:]
    var dictInt: [String: Int] = [:]
    var dictDictionary: [String: [String: String]] = [:]
    
    func string(forKey defaultName: String) -> String? {
        return dictString[defaultName]
    }
    
    func integer(forKey defaultName: String) -> Int {
        return dictInt[defaultName] ?? 0
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return dictDictionary[defaultName]
    }
    
    func setValue(_ value: Any?, forKey defaultName: String) {
        if let valueAsString = value as? String {
            dictString[defaultName] = valueAsString
        }
        
        if let valueAsInt = value as? Int {
            dictInt[defaultName] = valueAsInt
        }
        
        if let valueAsDictionaries = value as? [String: String] {
            dictDictionary[defaultName] = valueAsDictionaries
        }
    }
    
}
