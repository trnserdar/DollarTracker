//
//  LocaleManagerTests.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class LocaleManagerTests: XCTestCase {
    
    var sut: LocaleManager!
    var userDefaults: FakeUserDefaults!
    
    override func setUp() {
        super.setUp()
        sut = LocaleManager()
        userDefaults = FakeUserDefaults()
        sut.userDefaults = userDefaults
    }
    
    override func tearDown() {
        sut = nil
        userDefaults = nil
        super.tearDown()
    }
    
    func test_localeManager_conformsToLocaleManagerProtocol() {
        XCTAssertTrue((sut as AnyObject) is LocaleManagerProtocol)
    }
    
    func test_getApiKey_whenApiKeyEmpty_setApiKey() {
        XCTAssertNil(sut.getApiKey())
    }
    
    func test_getApiKey_whenGivenApiKey_setApiKey() {
        sut.setValue(value: "testApiKey", key: .apiKey)
        XCTAssertEqual(sut.getApiKey(), "testApiKey")
    }

    func test_getCurrencyTypes_whenCurrencyTypesEmpty_setCurrencyTypes() {
        XCTAssertNil(sut.getCurrencyTypes())
    }
    
    func test_getCurrencyTypes_whenGivenCurrencyTypes_setCurrencyTypes() {
        sut.setValue(value: ["EUR": "Euro"], key: .currencyTypes)
        let dict = sut.getCurrencyTypes()
        XCTAssertEqual(dict?["EUR"], "Euro")
    }
    
    func test_getDisplayMode_whenDisplayModeEmpty_setDisplayMode() {
        XCTAssertEqual(sut.getDisplayMode(), 0)
    }
    
    func test_getDisplayMode_whenGivenDisplayMode_setDisplayMode() {
        sut.setValue(value: 1, key: .displayMode)
        XCTAssertEqual(sut.getDisplayMode(), 1)
    }
    
    func test_getSelectedCurrency_whenSelectedCurrencyEmpty_setSelectedCurrency() {
        XCTAssertEqual(sut.getSelectedCurrencyType(), "EUR")
    }
    
    func test_getSelectedCurrency_whenGivenSelectedCurrency_setSelectedCurrency() {
        sut.setValue(value: "TRY", key: .selectedCurrencyType)
        XCTAssertEqual(sut.getSelectedCurrencyType(), "TRY")
    }

    
}
