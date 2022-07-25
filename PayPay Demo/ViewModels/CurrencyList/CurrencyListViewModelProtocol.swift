//
//  CurrencyListViewModelProtocol.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 25/7/22.
//

import Foundation
import Combine

protocol CurrencyListViewModelProtocol {
    var localCurrencyList: [String: String] { get set }
    var currencyList: [String: String]? { get set }

    var subscription: Set<AnyCancellable> { get set }
    var viewModel: CurrencyViewModel? { get set }

    func fetchCurrencyList()
    func fetchCurrencyListFromAPI(apiURL: HttpURL, params: [String: Any]?) async -> String?
}
