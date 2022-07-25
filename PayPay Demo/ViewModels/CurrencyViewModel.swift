//
//  CurrencyViewModel.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 20/7/22.
//

import Foundation
import Combine
import NotificationBannerSwift

class CurrencyViewModel {
    @LocalStorage(key: .lastAPIFetchedTime, defaultValue: Date())
    var lastAPIFetchedTime: Date // For saving the latest time when the API is updating.

    var currencyListViewModel: CurrencyListViewModel!
    @Published var currencyRateListViewModel: CurrencyRateListViewModel!

    var baseCurrency: String = "USD"
    var selectedCurrencyCode: String = "USD"

    var sortedCurrencyCode: [String]? {
        currencyListViewModel.currencyList?.sorted { $0.key < $1.key }.map { $0.key }
    }
    var sortedCurrencyCodeDetails: [String]? {
        currencyListViewModel.currencyList?.sorted { $0.key < $1.key }.map { $0.value }
    }

    init() {
        currencyListViewModel = CurrencyListViewModel(self)
        currencyRateListViewModel = CurrencyRateListViewModel(self)
    }

    func fetchData() {
        currencyListViewModel = CurrencyListViewModel(self)
        currencyRateListViewModel = CurrencyRateListViewModel(self)

        currencyListViewModel.fetchCurrencyList()
        currencyRateListViewModel.fetchCurrencyRateList()
    }
}

extension CurrencyViewModel {
    // Check if the last time API calling time is more than 30 minutes
    func isNotMoreThan30Min() -> Bool {
        let timePassed = Int(Date().timeIntervalSince(lastAPIFetchedTime))

        return timePassed < (30 * 60)
    }
}

extension CurrencyViewModel {
    // For updating the whole Currency Rate List into corresponding selected currency
    func updateCurrencyRate() {
        let currentRate = (currencyRateListViewModel.currencyRateList?[baseCurrency] ?? 0.0) / (currencyRateListViewModel.currencyRateList?[selectedCurrencyCode] ?? 0.0)
        baseCurrency = selectedCurrencyCode
        currencyRateListViewModel.currencyRateList?[selectedCurrencyCode] = 1

        for (k, v) in currencyRateListViewModel.currencyRateList ?? [:] {
            if k != selectedCurrencyCode {
                currencyRateListViewModel.currencyRateList?[k] = currentRate * v
            }
        }
    }
}
