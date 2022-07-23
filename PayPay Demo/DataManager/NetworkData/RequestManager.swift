//
//  RequestManager.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import Foundation
import Alamofire

struct RequestManager {
    public static let shared = RequestManager()

    typealias Response = (Data?, ErrorType?)

    func request(using url: HttpURL,
                        bodyParams: [String: Any]? = nil,
                        queryParams: [String: Any]? = nil,
                        pathParams: [String]? = nil,
                        parameterType: ParameterType,
                        type: RequestType,
                        header: HTTPHeaders? = nil) async -> Response {

        if !ReachabilityManager.shared.isReachable {
            DLog("No Internet.")
            return (nil, .noInternet)
        }

        var apiURL = URL(string: url.url)

        switch parameterType {
        case .query, .queryAndBody:
            apiURL = addQueryIntoURL(existingURL: apiURL, queryParams)
        case .path, .pathAndBody:
            apiURL = addPathIntoURL(existingURL: apiURL, pathParams)
        case .all:
            apiURL = addPathIntoURL(existingURL: apiURL, pathParams)

            apiURL = addQueryIntoURL(existingURL: apiURL, queryParams)
        }

        DLog("API URL: \(String(describing: apiURL))\nHeader data: \(String(describing: header))")

        guard let apiURL = apiURL else {
            return (nil, .unknownError("Invalid URL"))
        }

        let response = await AF.request(apiURL, method: HTTPMethod(rawValue: type.rawValue), parameters: bodyParams, encoding: JSONEncoding.default, headers: header).serializingData().response

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

extension RequestManager {
    func addPathIntoURL(existingURL: URL?, _ data: [String]?) -> URL? {
        var url = existingURL
        data?.forEach { (value) in
            url?.appendPathComponent(value)
        }

        return url
    }

    func addQueryIntoURL(existingURL: URL?, _ data: [String: Any]?) -> URL? {
        var url = existingURL
        var components = URLComponents(string: url?.absoluteString ?? "")
        components?.queryItems = data?.map { URLQueryItem(name: $0, value: $1 as? String) }
        url = components?.url

        return url
    }
}
