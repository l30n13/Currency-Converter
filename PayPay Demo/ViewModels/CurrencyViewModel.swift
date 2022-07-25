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
    var lastAPIFetchedTime: Date

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
    func isNotMoreThan30Min() -> Bool {
        let timePassed = Int(Date().timeIntervalSince(lastAPIFetchedTime))

        return timePassed < (30 * 60)
    }
}

extension CurrencyViewModel {
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
