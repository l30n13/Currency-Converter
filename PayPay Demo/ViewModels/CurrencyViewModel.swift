//
//  CurrencyViewModel.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 20/7/22.
//

import Foundation

struct CurrencyViewModel {
    public var currencyList: CurrenciesModel?

    private let session = URLSession.shared

    mutating func fetchAllCurrencies() async throws {
        let (result, error) = try await session.data(from: URL(string: "https://openexchangerates.org/api/currencies.json?app_id=8204926d529943e7b59cc082e4a6dc8c")!)

        let arrayData = String(data: result, encoding: .utf8)?
            .replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .components(separatedBy: ",")


        var currencyList: [String : String] = [:]

        arrayData?.forEach({ data in
            let split = data.components(separatedBy: ": ")
            currencyList[split[0].replacingOccurrences(of: " ", with: "")] = split[1]
        })

        self.currencyList = CurrenciesModel(currency: currencyList)

    }

}
