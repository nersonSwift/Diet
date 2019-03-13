//
//  Session.swift
//  Diet
//
//  Created by Даниил on 10/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ExpirationReason: Int {
    case customerCanceled = 1
    case billingError = 2
    case customerDisagreePriceIncrease = 3
    case productWasNotAvailableDuringRenewal = 4
    case unknownError = 5
    
    var description: String {
        get {
            switch self {
            case .customerCanceled:
                return "Customer canceled subscription".localized
            case .billingError:
                return "Billing error occured".localized
            case .customerDisagreePriceIncrease:
                return "Customer did not agree to recent price increase".localized
            case .productWasNotAvailableDuringRenewal:
                return "Product was not available for purchase at the time of renewal".localized
            case .unknownError:
                return "Subscription has been expired due unknown error".localized
            }
        }
    }
}

struct Session {
    
    let id: SessionId
    let paidSubscriptions: [PaidSubscription]
    public var receiptData: Data
    public var parsedReceipt: [String: Any]

    public var currentSubscription: PaidSubscription? {
        let activeSubscriptions = paidSubscriptions.filter { $0.isActive && $0.purchaseDate >= SubscriptionNetworkService.shared.simulatedStartDate }
        
        var current = activeSubscriptions.last
        
        paidSubscriptions.forEach {
            if $0.isTrial == true {
                current?.isEligibleForTrial = false
            }
        }
        return current
    }
    
    public var isEligibleForTrial: Bool {
        
        for sub in paidSubscriptions {
            if sub.isTrial == true && paidSubscriptions.count != 1 {
                UserDefaults.standard.set(true, forKey: "isTrialExpired")
                return false
            }
        }
        UserDefaults.standard.set(false, forKey: "isTrialExpired")
        return true
    }
    
    init(receiptData: Data, parsedReceipt: [String: Any]) {
        id = UUID().uuidString
        self.receiptData = receiptData
        self.parsedReceipt = parsedReceipt
        if let purchases = JSON(parsedReceipt)["latest_receipt_info"].array {
            var subscriptions = [PaidSubscription]()
            for purchase in purchases {
                let paidSubscription = PaidSubscription(productId: purchase["product_id"].stringValue,
                                                        purchaseDateString: purchase["purchase_date"].stringValue,
                                                        expiresDateString: purchase["expires_date"].stringValue,
                                                        isTrial: purchase["is_trial_period"].stringValue)
                subscriptions.append(paidSubscription)
            }
            paidSubscriptions = subscriptions
        } else {
            paidSubscriptions = []
        }
    }
}

extension Session: Equatable {
    public static func ==(lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id
    }
}
