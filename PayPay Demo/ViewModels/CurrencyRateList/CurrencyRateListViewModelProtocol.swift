//
//  CurrencyRateListViewModelProtocol.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 25/7/22.
//

import Foundation
import Combine

protocol CurrencyRateListViewModelProtocol {
    var localCurrencyRateList: [String: Double] { get set }
    var currencyRateList: [String: Double]? { get set }
    var subscription: Set<AnyCancellable> { get set }
    var viewModel: CurrencyViewModel? { get set }

    func fetchCurrencyRateList()
    func fetchCurrencyRatesFromAPI(apiURL: HttpURL, params: [String: Any]?) async -> String?
}
