//
//  CurrencyViewModelTests.swift
//  PayPay DemoTests
//
//  Created by Mahbubur Rashid Leon on 23/7/22.
//

import XCTest
@testable import PayPay_Demo

class CurrencyViewModelTests: XCTestCase {
    var currencyViewModel: CurrencyViewModel?

    override func setUpWithError() throws {
        currencyViewModel = CurrencyViewModel()
        currencyViewModel?.lastAPIFetchedTime = Date()
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: LocalStorageKeys.lastAPIFetchedTime.rawValue)
    }

    func test_is_currency_list_view_model_instance_is_created() {
        XCTAssertNotNil(currencyViewModel?.currencyListViewModel)
    }

    func test_is_currency_list_rate_view_model_instance_is_created() {
        XCTAssertNotNil(currencyViewModel?.currencyRateListViewModel)
    }

    func test_is_not_more_than_30_min_return_true() {
        let result = currencyViewModel?.isNotMoreThan30Min()

        XCTAssertTrue(result ?? false, "It should return TRUE but returned FALSE")
    }

    func test_is_not_more_than_30_min_return_false() {
        currencyViewModel?.lastAPIFetchedTime = Date().addingTimeInterval(-(35*60))
        let result = currencyViewModel?.isNotMoreThan30Min()

        XCTAssertFalse(result ?? false, "It should return TRUE but returned FALSE")
    }
}
