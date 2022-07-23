//
//  LocalStorageManager.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid Leon on 22/7/22.
//

import Foundation

public enum LocalStorageKeys: String, CaseIterable {
    case currencyNameList           = "currencyNameList"
    case currencyConversionRateList = "currencyConversionRateList"
    case lastAPIFetchedTime         = "lastAPIFetchedTime"
}

@propertyWrapper
struct LocalStorage<T> {
    private let defaultValue: T
    private let key: LocalStorageKeys
    private let container: UserDefaults

    var wrappedValue: T {
        get {
            container.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key.rawValue)
        }
    }

    public init(key: LocalStorageKeys, defaultValue: T, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
}
