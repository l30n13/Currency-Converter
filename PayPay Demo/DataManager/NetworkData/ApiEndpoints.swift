//
//  ApiEndpoints.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import Foundation

let APP_ID = "8204926d529943e7b59cc082e4a6dc8c"

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
