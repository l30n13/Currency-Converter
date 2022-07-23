//
//  CurrencyViewModel.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 20/7/22.
//

import Foundation
import NotificationBannerSwift

class CurrencyViewModel {
    @LocalStorage(key: .currencyNameList, defaultValue: [:])
    var localCurrencyList: [String: String]

    @LocalStorage(key: .currencyConversionRateList, defaultValue: [:])
    var localCurrencyRateList: [String: Double]

    @LocalStorage(key: .lastAPIFetchedTime, defaultValue: Date())
    var lastAPIFetchedTime: Date

    @Published var currencyList: [String: String]?
    @Published var currencyRateList: [String: Double]?

    func fetchData() {
        fetchCurrencyList()
        fetchCurrencyRateList()
    }

    private func fetchCurrencyList() {
        if localCurrencyList.count > 0 && isNotMoreThan30Min() {
            currencyList = localCurrencyList
        } else {
            Task {
                _ = await fetchCurrencyListFromAPI()
                lastAPIFetchedTime = Date.now
            }
        }
    }

    private func fetchCurrencyListFromAPI() async -> String? {
        let params = [
            "app_id": APP_ID
        ] as? [String: Any]

        let (result, error) = await RequestManager.shared.request(using: .CURRENCIES_JSONN, queryParams: params, parameterType: .query, type: .get)

        if let error = error {
            switch error {
            case .noInternet:
                await FloatingNotificationBanner(title: "No Internet!!!", subtitle: "There is no internet. Please connect to internet and try again.", style: .warning).show()
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

    private func fetchCurrencyRateList() {
        if localCurrencyRateList.count > 0 && isNotMoreThan30Min() {
            currencyRateList = localCurrencyRateList
        } else {
            Task {
                _ = await fetchCurrencyRatesFromAPI()
                lastAPIFetchedTime = Date.now
            }
        }
    }

    private func fetchCurrencyRatesFromAPI() async -> String? {
        let params = [
            "app_id": APP_ID
        ] as? [String: Any]

        let (result, error) = await RequestManager.shared.request(using: .LATEST_JSON, queryParams: params, parameterType: .query, type: .get)

        if let error = error {
            switch error {
            case .noInternet:
                await FloatingNotificationBanner(title: "No Internet!!!", subtitle: "There is no internet. Please connect to internet and try again.", style: .warning).show()
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
        let currencyRateList: [String: Double] = json?["rates"] as! [String: Double]

        self.currencyRateList = currencyRateList
        localCurrencyRateList = currencyRateList

        return nil
    }
}

extension CurrencyViewModel {
    func isNotMoreThan30Min() -> Bool {
        let timePassed = Int(Date().timeIntervalSince(lastAPIFetchedTime))

        return timePassed < (30 * 60)
    }
}
