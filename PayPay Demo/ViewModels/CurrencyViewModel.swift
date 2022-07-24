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

    var currencyistViewModel: CurrenctListViewModel!
    @Published var currencyRateListViewModel: CurrencyRateListViewModel!

    var baseCurrency: String = "USD"
    var selectedCurrencyCode: String = "USD"

    var sortedCurrencyCode: [String]? {
        currencyistViewModel.currencyList?.sorted { $0.key < $1.key }.map { $0.key }
    }
    var sortedCurrencyCodeDetails: [String]? {
        currencyistViewModel.currencyList?.sorted { $0.key < $1.key }.map { $0.value }
    }

    init() {
        currencyistViewModel = CurrenctListViewModel(self)
        currencyRateListViewModel = CurrencyRateListViewModel(self)
    }

    func fetchData() {
        currencyistViewModel = CurrenctListViewModel(self)
        currencyRateListViewModel = CurrencyRateListViewModel(self)

        currencyistViewModel.fetchCurrencyList()
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
