//
//  CurrencyListViewModel.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 24/7/22.
//

import Foundation
import Combine

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    @LocalStorage(key: .currencyNameList, defaultValue: [:])
    var localCurrencyList: [String: String]

    @Published var currencyList: [String: String]?

    var subscription = Set<AnyCancellable>()

    weak var viewModel: CurrencyViewModel?

    init(_ viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
    }

    func fetchCurrencyList() {
        ReachabilityManager.shared.$isReachable.sink { [unowned self] isReachable in
            guard isReachable else {
                currencyList = localCurrencyList
                return
            }

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
        }.store(in: &subscription)
    }

    internal func fetchCurrencyListFromAPI(apiURL: HttpURL, params: [String: Any]?) async -> String? {
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

        let currencyList: [String: String] = json as! [String: String]

        self.currencyList = currencyList
        localCurrencyList = currencyList

        return nil
    }
}
