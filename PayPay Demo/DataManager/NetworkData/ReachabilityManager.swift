//
//  ReachabilityManager.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import Foundation
import Alamofire
import NotificationBannerSwift

class ReachabilityManager {
    var reachability: NetworkReachabilityManager?

    var isReachable = true
    static let shared: ReachabilityManager = ReachabilityManager()

    private init() {
        reachability = NetworkReachabilityManager()
    }

    func startListing() {
        reachability?.startListening(onUpdatePerforming: { [unowned self] (status) in
            if status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi) {
                isReachable = true
                NotificationCenter.default.post(name: .internetChanged, object: true)
            } else {
                isReachable = false
                NotificationCenter.default.post(name: .internetChanged, object: false)
                FloatingNotificationBanner(title: "No Internet!!!", subtitle: "There is no internet. Please connect to internet and try again.", style: .warning).show()
            }
            DLog("Listing...")
        })
    }

    func stopListening() {
        reachability?.stopListening()
        DLog("Stopped Listing...")
    }
}
