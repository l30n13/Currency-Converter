//
//  CurrencyListViewModelTests.swift
//  PayPay DemoTests
//
//  Created by Mahbubur Rashid on 25/7/22.
//

import XCTest
@testable import PayPay_Demo

class CurrencyListViewModelTests: XCTestCase {
    var viewModel: MockCurrencyListViewModel?

    override func setUpWithError() throws {
        viewModel = MockCurrencyListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel?.currencyList = nil
        viewModel?.localCurrencyList = [:]
    }

    func test_check_if_currency_list_is_getting_the_right_data() {
        let expectation = expectation(description: "Currency List fetch exceptions")

        viewModel?.fetchCurrencyList()

        guard let viewModel = viewModel else {
            return
        }

        var currencyList: [String: String] = [:]
        viewModel.$currencyList.sink { data in
            guard let data = data else {
                return
            }

            currencyList = data
            expectation.fulfill()
        }.store(in: &viewModel.subscription)

        XCTAssertNotNil(currencyList, "Should not be nil")
        XCTAssertNotNil(viewModel.localCurrencyList, "Local currency data should not be nil")

        XCTAssertEqual(currencyList["USD"], viewModel.currencyList?["USD"], "Should be equal to view model currency list data")
        XCTAssertEqual(currencyList["USD"], viewModel.localCurrencyList["USD"], "Local currency data should be equal to view model currency list data")

        XCTAssertEqual(currencyList, viewModel.currencyList ?? [:], "Should be equal to view model currency list data")
        XCTAssertEqual(currencyList, viewModel.localCurrencyList, "Local currency list data should be equal to view model currency list data")

        wait(for: [expectation], timeout: 30)
    }
}
