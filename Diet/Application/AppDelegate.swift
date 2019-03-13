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
import UserNotifications
import CoreData

enum ProductId: String {
    case popular = "com.sfbtech.diets.sub.week.allaccess"
    case cheap = "com.sfbtech.diets.sub.month.allaccess"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchManager: LaunchManager?
    
    // MARK: Notifications
    private func setupLocalNotifications() {
        
        var dateComponents = DateComponents()
        
        // monday
        dateComponents.weekday = 2
        dateComponents.hour = 12
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "New recipes!".localized
        notificationContent.body = "Check out new recipes".localized
        notificationContent.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "NEW_DIET", content: notificationContent, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                
            }
        }
    }
    
    // MARK: App life cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("PATH ",paths[0])
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (isAllowed, error) in
            if isAllowed {
                self.setupLocalNotifications()
            } else {
                print("Permission has not been granted")
            }
        }
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        Purchases.configure(withAPIKey: "KFbzbXGcfYLysGfIQnsbshOePruacVgF", appUserID: nil)
        
         launchManager = LaunchManager(window: window!)
         launchManager?.prepareForLaunch()
        
//        let vc = DietViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
//        let vc = TestPageViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
//        let vc = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil), identifier: "SubscriptionOffer")
//        window?.rootViewController = vc
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
