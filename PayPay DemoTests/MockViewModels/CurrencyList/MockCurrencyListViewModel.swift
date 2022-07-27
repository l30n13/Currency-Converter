//
//  MockCurrencyListViewModel.swift
//  PayPay DemoTests
//
//  Created by Mahbubur Rashid Leon on 26/7/22.
//

import Foundation
import Combine

@testable import PayPay_Demo

class MockCurrencyListViewModel: CurrencyListViewModelProtocol {
    @LocalStorage(key: .currencyNameList, defaultValue: [:])
    var localCurrencyList: [String: String]

    @Published var currencyList: [String: String]?

    var subscription: Set<AnyCancellable> = []

    var viewModel: CurrencyViewModel?

    init() {
        viewModel = CurrencyViewModel()
    }

    func fetchCurrencyList() {
        guard let viewModel = viewModel else {
            return
        }

        if localCurrencyList.count > 0 && viewModel.isNotMoreThan30Min() {
            currencyList = localCurrencyList
        } else {
            Task {
                let params = [
                    "app_id": APP_ID
                ] as? [String: Any]

                _ = await fetchCurrencyListFromAPI(apiURL: .CURRENCIES_JSONN, params: params)
                viewModel.lastAPIFetchedTime = Date.now
            }
        }
    }

    func fetchCurrencyListFromAPI(apiURL: HttpURL, params: [String: Any]?) async -> String? {
        let (result, error) = await RequestManager.shared.request(using: apiURL, queryParams: params, parameterType: .query, type: .get)

        if let error = error {
            switch error {
            case .noInternet:
                return "No Internet"
            case .unknownError:
                return "Unknown Error"
            case .errorDescription,
                    .networkProblem:
                return "Network Problem"
            }
        }

        guard let result = result else {
            return "Data retrieve error"
        }

        let json = try? JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String: AnyObject]

        // Converting data into Dictionary
        let currencyList: [String: String] = json as! [String: String]

        self.currencyList = currencyList
        localCurrencyList = currencyList

        return nil
    }
}
