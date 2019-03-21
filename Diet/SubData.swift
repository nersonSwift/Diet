//
//  SubData.swift
//  Diet
//
//  Created by Александр Сенин on 18/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import AppsFlyerLib

enum ProductId: String {
    case popular = "com.sfbtech.diets.sub.week.allaccess"
    case cheap = "com.sfbtech.diets.sub.month.allaccess"
    case sharedSecret = "41b8fe92dbd9448ab3e06f3507b01371"
}

class SubData{
    var activeSub = false
    var activeTrial = false
    
    init(){
        refrash(completion: nil)
    }
    
    func refrash(completion: (()->())?){
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: ProductId.sharedSecret.rawValue)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            if case .success(let receipt) = result {
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable,
                                                                       productId: ProductId.popular.rawValue,
                                                                       inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(_, let receiptItems):
                    self.activeSub = true
                    let trial = receiptItems.filter { $0.isTrialPeriod == true}
                    let dateEndTrial = trial[0].purchaseDate + 60 * 60 * 24 * 3
                    if dateEndTrial > Date(){
                        self.activeTrial = true
                    }
                case .expired(let expiryDate):
                    print("Product is expired since \(expiryDate)")
                    self.activeSub = false
                case .notPurchased:
                    print("This product has never been purchased")
                    self.activeSub = false
                }
            }
            completion?()
        }
    }
    
    func goSub(completion: (()->())?){
        SwiftyStoreKit.purchaseProduct(ProductId.popular.rawValue, atomically: true){ result in
            switch result{
            case .success(let purchase):
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                self.refrash(completion: completion)
            case .error: break
            }
        }
    }
}
