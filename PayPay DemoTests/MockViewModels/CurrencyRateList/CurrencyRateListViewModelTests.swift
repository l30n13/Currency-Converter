//
//  CurrencyRateListViewModelTests.swift
//  PayPay DemoTests
//
//  Created by Mahbubur Rashid Leon on 26/7/22.
//

import XCTest
@testable import PayPay_Demo

class CurrencyRateListViewModelTests: XCTestCase {
    var viewModel: MockCurrencyRateListViewModel?

    override func setUpWithError() throws {
        viewModel = MockCurrencyRateListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel?.currencyRateList = nil
        viewModel?.localCurrencyRateList = [:]
    }

    func test_check_if_currency_rate_list_is_getting_the_right_data() {
        let expectation = expectation(description: "Currency Rate List fetch exceptions")

        viewModel?.fetchCurrencyRateList()

        guard let viewModel = viewModel else {
            return
        }

        var currencyRateList: [String: Double] = [:]
        viewModel.$currencyRateList.sink { data in
            guard let data = data else {
                return
            }

            currencyRateList = data
            expectation.fulfill()
        }.store(in: &viewModel.subscription)

        XCTAssertNotNil(currencyRateList, "Should not be nil")
        XCTAssertNotNil(viewModel.localCurrencyRateList, "Local currency data should not be nil")

        XCTAssertEqual(currencyRateList["USD"], viewModel.currencyRateList?["USD"], "Should be equal to view model currency list data")
        XCTAssertEqual(currencyRateList["USD"], viewModel.localCurrencyRateList["USD"], "Local currency data should be equal to view model currency list data")

        XCTAssertEqual(currencyRateList, viewModel.currencyRateList ?? [:], "Should be equal to view model currency list data")
        XCTAssertEqual(currencyRateList, viewModel.localCurrencyRateList, "Local currency list data should be equal to view model currency list data")

        wait(for: [expectation], timeout: 30)
    }
}
