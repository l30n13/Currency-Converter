//
//  CurrencyListViewModel.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 24/7/22.
//

import Foundation
import Combine

class CurrenctListViewModel {
    @LocalStorage(key: .currencyNameList, defaultValue: [:])
    var localCurrencyList: [String: String]

    @Published var currencyList: [String: String]?

    private var subscription = Set<AnyCancellable>()

    private weak var viewModel: CurrencyViewModel?

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
                    _ = await fetchCurrencyListFromAPI()
                    viewModel.lastAPIFetchedTime = Date.now
                }
            }
        }.store(in: &subscription)
    }

    private func fetchCurrencyListFromAPI() async -> String? {
        let params = [
            "app_id": APP_ID
        ] as? [String: Any]

        let (result, error) = await RequestManager.shared.request(using: .CURRENCIES_JSONN, queryParams: params, parameterType: .query, type: .get)

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