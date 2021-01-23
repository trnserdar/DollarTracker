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
    
    override func setUp() {
        super.setUp()
        sut = AppDelegate()
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initAppDelegate_setStatusItemTitle() {
        XCTAssertEqual(sut.statusItem?.button?.title, "Dollar Tracker")
    }

}
