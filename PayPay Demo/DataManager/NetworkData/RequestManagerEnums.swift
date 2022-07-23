//
//  RequestManagerEnums.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid Leon on 22/7/22.
//

import Foundation

enum RequestType: String, CaseIterable {
    case get    = "GET"
    case post   = "POST"
}

enum ErrorType: Error {
    case noInternet
    case networkProblem
    case unknownError(String)
    case errorDescription(Error)
}

enum ParameterType {
    case query
    case queryAndBody
    case path
    case pathAndBody
    case all
}
