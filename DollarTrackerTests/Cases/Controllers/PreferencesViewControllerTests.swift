//
//  PreferencesViewControllerTests.swift
//  DollarTrackerTests
//
//  Created by SERDAR TURAN on 25.01.2021.
//

import XCTest
@testable import DollarTracker

class PreferencesViewControllerTests: XCTestCase {

    var sut: PreferencesViewController!
    var localeManager: MockLocaleManager!
    var networkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        sut = storyboard.instantiateController(withIdentifier: PreferencesViewController.storyboardId) as? PreferencesViewController
        localeManager = MockLocaleManager()
        sut.localeManager = localeManager
        networkManager = MockNetworkManager()
        sut.networkManager = networkManager
        sut.loadView()
    }
    
    override func tearDown() {
        sut = nil
        localeManager = nil
        networkManager = nil
        super.tearDown()
    }
    
    func test_getLocale_whenApiKeyEmpty_setTextFieldText() {
        sut.viewWillAppear()
        XCTAssertEqual(sut.apiKeyTextField.stringValue, "Please enter api key")
    }
    
    func test_getLocale_whenGivenApiKey_setTextFieldText() {
        localeManager.setValue(value: "12345", key: .apiKey)
        sut.viewWillAppear()
        XCTAssertEqual(sut.apiKeyTextField.stringValue, "12345")
    }
    
    func test_getLocale_whenCurrencyTypesEmpty_setCurrencyMenuItemsCount() {
        localeManager.setValue(value: nil, key: .currencyTypes)
        sut.viewWillAppear()
        XCTAssertEqual(sut.currencyMenu.menu?.items.count, 0)
    }
    
    func test_getLocale_whenCurrencyTypesEmpty_setCurrencyTypesCount() {
        localeManager.setValue(value: nil, key: .currencyTypes)
        sut.viewWillAppear()
        XCTAssertEqual(networkManager.currencyTypesCount, 1)
    }
    
    func test_getLocale_whenGivenCurrencyTypes_setCurrencyMenuItemsCount() {
        localeManager.setValue(value: ["EUR": "Euro", "TRY": "Turkish Lira"], key: .currencyTypes)
        sut.viewWillAppear()
        let expectationTypes = expectation(description: "Currency Types")
        DispatchQueue.main.async {
            expectationTypes.fulfill()
        }
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(sut.currencyMenu.menu?.items.count, 2)
    }
    
    func test_getCurrencyTypes_whenEmptyCurrencyTypes_setMenuItems() {
        let expectationTypes = expectation(description: "Currency Types")
        localeManager.setValue(value: nil, key: .currencyTypes)
        sut.viewWillAppear()
        networkManager.currencyTypesCompletion?(nil)
        DispatchQueue.main.async {
            expectationTypes.fulfill()
        }
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(sut.currencyMenu.menu?.items.count, 0)
    }
    
    func test_getCurrencyTypes_whenGivenCurrencyTypes_setMenuItems() {
        let expectationTypes = expectation(description: "Currency Types")
        localeManager.setValue(value: nil, key: .currencyTypes)
        sut.viewWillAppear()
        networkManager.currencyTypesCompletion?(["EUR": "Euro", "TRY": "Turkish Lira"])
        DispatchQueue.main.async {
            expectationTypes.fulfill()
        }
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(sut.currencyMenu.menu?.items.count, 2)
    }
    
    func test_currencyMenuSelected_whenSelectedItemEmpty_setSelectedCurrency() {
        localeManager.setValue(value: nil, key: .currencyTypes)
        sut.currencyMenuSelected(sut.currencyMenu!)
        XCTAssertEqual(localeManager.getSelectedCurrencyType(), "EUR")
    }
    
    func test_currencyMenuSelected_whenGivenCurrencyTypes_setSelectedCurrency() {
        
        for (code, currency) in ["EUR": "Euro", "TRY": "Turkish Lira"].sorted(by: <) {
            sut.currencyMenu.menu?.addItem(NSMenuItem(title: "\(code): \(currency)", action: nil, keyEquivalent: ""))
        }
        sut.currencyMenu.select(sut.currencyMenu!.menu?.items[1])
        sut.currencyMenuSelected(sut.currencyMenu!)
        XCTAssertEqual(localeManager.getSelectedCurrencyType(), "TRY")
    }
    
    func test_setLocale_setApiKey() {
        sut.apiKeyTextField.stringValue = "test"
        sut.viewWillDisappear()
        XCTAssertEqual(localeManager.getApiKey(), "test")
    }
    
    func test_setLocale_setDisplayMode() {
        sut.displayModeMenu.selectItem(at: 1)
        sut.viewWillDisappear()
        XCTAssertEqual(localeManager.getDisplayMode(), 1)
    }
    
    func test_setLocale_setSelectedCurrency() {
        for (code, currency) in ["EUR": "Euro", "TRY": "Turkish Lira"].sorted(by: <) {
            sut.currencyMenu.menu?.addItem(NSMenuItem(title: "\(code): \(currency)", action: nil, keyEquivalent: ""))
        }
        sut.currencyMenu.select(sut.currencyMenu!.menu?.items[1])
        sut.viewWillDisappear()
        XCTAssertEqual(localeManager.getSelectedCurrencyType(), "TRY")
    }
}
