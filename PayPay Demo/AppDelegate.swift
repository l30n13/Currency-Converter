//
//  AppDelegate.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 20/7/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupEntryPoint()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.stopListening()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.stopListening()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.startListing()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.stopListening()
    }
}

extension AppDelegate {
    fileprivate func setupEntryPoint() {
        let viewController = CurrencyConverterVC()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        let window = UIWindow()
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
