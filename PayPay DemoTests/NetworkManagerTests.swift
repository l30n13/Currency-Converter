//
//  NetworkManagerTests.swift
//  PayPay DemoTests
//
//  Created by Mahbubur Rashid Leon on 23/7/22.
//

import XCTest
@testable import PayPay_Demo

class NetworkManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_is_add_path_into_url_is_OK() {
        let params = [
            "path1",
            "path2"
        ]
        let url  = URL(string: "https://testme.com")
        let updatedURL = RequestManager.shared.addPathIntoURL(existingURL: url, params)

        XCTAssertEqual("https://testme.com/path1/path2", updatedURL!.absoluteString, "URL is not right")
    }

    func test_is_add_query_into_url_is_OK() {
        let params = [
            "path1": "path1"
        ]
        let url  = URL(string: "https://testme.com")
        let updatedURL = RequestManager.shared.addQueryIntoURL(existingURL: url, params)

        XCTAssertEqual("https://testme.com?path1=path1", updatedURL!.absoluteString, "URL is not right")
    }
}
