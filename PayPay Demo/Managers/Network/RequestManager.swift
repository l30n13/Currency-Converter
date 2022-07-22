//
//  RequestManager.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import Foundation
import Alamofire

struct RequestManager {
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

    typealias response = (Data?, ErrorType?)

    static func request(using url: HttpURL,
                        params: [String: AnyObject]?,
                        type: RequestType,
                        header: HTTPHeaders? = nil) async -> response {

        DLog("API URL: \(url)\nHeader data: \(String(describing: header))")

        if !ReachabilityManager.sharedInstance.isReachable {
            DLog("No Internet.")
            return (nil, .noInternet)
        }

        let response = await AF.request(url.url, method: HTTPMethod(rawValue: type.rawValue), parameters: params, encoding: JSONEncoding.default, headers: header).serializingData().response

        guard let statusCode = response.response?.statusCode else {
            return (nil, .unknownError("Unknown error"))
        }

        switch statusCode {
        case 200, 201:
            switch response.result {
            case .success(let responseData):
                return (responseData, nil)
            case .failure(let error):
                return (nil, .errorDescription(error))
            }
        case 400 ... 500:
            return (nil, .networkProblem)
        default:
            return (nil, .networkProblem)
        }
    }
}
