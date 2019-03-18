//
//  AppDelegate.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore
import Purchases
import SwiftyStoreKit
import AppsFlyerLib
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // MARK: App life cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("PATH ",paths[0])
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                }
            }
        }
        
        Purchases.configure(withAPIKey: "KFbzbXGcfYLysGfIQnsbshOePruacVgF", appUserID: nil)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        AppsFlyerTracker.shared().appsFlyerDevKey = "RB7d2qzpNfUwBdq4saReqk"
        AppsFlyerTracker.shared().appleAppID = "1445711141"
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    
}

extension AppDelegate: AppsFlyerTrackerDelegate {
    
    func onConversionDataReceived(_ installData: [AnyHashable : Any]!) {
        
        if var data = installData {
            data["rc_appsflyer_id"] = AppsFlyerTracker.shared().getAppsFlyerUID()
            Purchases.shared.addAttributionData(data, from: .appsFlyer)
        }
    }
}
