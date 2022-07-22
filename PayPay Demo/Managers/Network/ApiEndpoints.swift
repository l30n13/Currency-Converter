//
//  ApiEndpoints.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import Foundation

enum HttpURL: String {
    case LATEST_JSON           = "latest.json"
    case CURRENCIES_JSONN      = "currencies.json"

    private var BASE_URL: String {
        return "https://openexchangerates.org/api/"
    }

    var url: String {
        switch self {
        case .LATEST_JSON,
                .CURRENCIES_JSONN:
            return BASE_URL + rawValue
        }
    }
}
