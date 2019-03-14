//
//  SubscriptionService.swift
//  Diet
//
//  Created by Даниил on 10/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionService: NSObject {
    
    static let sessionIdSetNotification = Notification.Name("SubscriptionServiceSessionIdSetNotification")
    static let optionsLoadedNotification = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
    static let restoreSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
    static let purchaseSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
    static let nothingToRestoreNotification = Notification.Name("SubscriptionServiceNoTransactionsToRestore")
    static let purchaseFailedNotification = Notification.Name("SubscriptionPurchaseFailedNotification")
    static let noSubscriptionAfterAutoCheckNotification = Notification.Name("NoSubscriptionAfterAutoCheck")
    
    static let shared = SubscriptionService()
    var optionsLoaded: ((Subscription) -> ())?
    
    var hasReceiptData: Bool {
        return loadReceipt() != nil
    }
    
    var options: [Subscription]? {
        didSet {
            if let option = options?.first {
                optionsLoaded?(option)
            }
            NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: options)
        }
    }
    
    var currentSessionId: String? {
        didSet {
            NotificationCenter.default.post(name: SubscriptionService.sessionIdSetNotification, object: currentSessionId)
        }
    }
    
    var isEligibleForTrial = true
    
    var currentSubscription: PaidSubscription?
    
    func loadSubscriptionOptions() {
        
        let productIDPrefix = Bundle.main.bundleIdentifier! + ".sub."
        let oneAWeekAllAccess = productIDPrefix + "week.allaccess"
        
        let productIDs = Set([oneAWeekAllAccess])
        
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    private func loadReceipt() -> Data? {
        
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func purchase(subscription: Subscription) {
        let payment = SKPayment(product: subscription.product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension SubscriptionService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { Subscription(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
}
