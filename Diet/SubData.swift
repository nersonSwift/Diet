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
    case moon = "com.sfbtech.diets.sub.moon.allaccess"
    case moonT = "com.sfbtech.diets.sub.moont.allaccess"
    case quarterly = "com.sfbtech.diets.sub.quarterly.allaccess"
    case sharedSecret = "41b8fe92dbd9448ab3e06f3507b01371"
    
    var trial: Int{
        
        switch self {
            
        case .popular:
            return 3
            
        case .cheap:
            return 7
            
        case .moon:
            return 3
            
        case .moonT:
            return 7
            
        default: return 0
        }
    }
}

class SubData{
    var activeSub = false
    var activeTrial = false
    var prises: [ProductId: String] = [.moon: "...",
                                       .moonT: "...",
                                       .quarterly: "..."]
 
    init(){
        refrash(completion: nil)
    }
    
    func refrash(completion: (()->())?){
        activeSub = false
        activeTrial = false
        var comp = 0{
            didSet{
                if comp == 2{
                    completion?()
                }
            }
        }
        SwiftyStoreKit.retrieveProductsInfo([ProductId.moonT.rawValue, ProductId.moon.rawValue, ProductId.quarterly.rawValue]) { result in
            for plan in result.retrievedProducts{
                self.prises[ProductId(rawValue: plan.productIdentifier)!] = plan.localizedPrice
            }
            comp += 1
        }
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: ProductId.sharedSecret.rawValue)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            if case .success(let receipt) = result {
                for i in [ProductId.popular, ProductId.cheap, ProductId.moon, ProductId.moonT, ProductId.quarterly]{
                    let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable,
                                                                           productId: i.rawValue,
                                                                           inReceipt: receipt)
                    
                    switch purchaseResult {
                    case .purchased(_, let receiptItems):
                        print(receiptItems)
                        self.activeSub = true
                        let trial = receiptItems.filter { $0.isTrialPeriod == true}
                        if trial.count > 0{
                            let dateEndTrial = trial[0].purchaseDate + TimeInterval(60 * 60 * 24 * i.trial)
                            if dateEndTrial > Date(){
                                self.activeTrial = true
                            }
                        }
                    case .expired(let expiryDate):
                        print("Product is expired since \(expiryDate)")
                    case .notPurchased:
                        print("This product has never been purchased")
                    }
                }
            comp += 1
            }
        }
    }
    
    func goSub(productId: String, completion: (()->())?){
        SwiftyStoreKit.purchaseProduct(productId, atomically: true){ result in
            
            switch result{
            case .success(let purchase):
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                self.refrash(completion: completion)
            case .error:
                self.refrash(completion: completion)
            }
        }
    }
}
