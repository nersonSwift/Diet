//
//  LaunchManager.swift
//  Diet
//
//  Created by Даниил on 11/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import SwiftyStoreKit

protocol ContentAccessHandler: class {
    
    func accessIsDenied()
    func accessIsAvailable()
}

enum AccessStatus {
    case available
    case denied
}

class LaunchManager: NSObject {
    
    private let mainWindow: UIWindow
    weak var handler: ContentAccessHandler?
    
    init(window: UIWindow) {
        self.mainWindow = window
    }
    
    func verifyReceipt() {
        
        let loadingVC = LoadingViewController()
        loadingVC.view.backgroundColor = .lightGray
        mainWindow.rootViewController = loadingVC
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "41b8fe92dbd9448ab3e06f3507b01371")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let receipt):
                
                let verificationResult = SwiftyStoreKit.verifySubscriptions(productIds: [ProductId.popular.rawValue, ProductId.cheap.rawValue], inReceipt: receipt)
                switch verificationResult {
                case .purchased(let receiptItems):
                    
                    let dietVc = DietView.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
                    dietVc.accessStatus = .available
                    self.mainWindow.rootViewController = dietVc
                    
                    let reseprTrial = receiptItems.items.filter { $0.isTrialPeriod == false }[0]
                    var endTrialDate = reseprTrial.purchaseDate
                    
                    switch ProductId.init(rawValue: reseprTrial.productId)!{
                    case .popular:
                        endTrialDate += 60 * 60 * 24 * 3
                    case .cheap:
                        endTrialDate += 60 * 60 * 24 * 7
                    }
                    print(endTrialDate)
                    if endTrialDate <= Date(){
                        
                    }
                    
                default:
                    
                    let subOfferVc = SubscriptionOfferView.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil), identifier: "SubscriptionOffer")
                    self.mainWindow.rootViewController = subOfferVc
        
                }
            case .error(let error):
                print("Error ",error.localizedDescription)
                let subOfferVc = SubscriptionOfferView.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil), identifier: "SubscriptionOffer")
                self.mainWindow.rootViewController = subOfferVc
            }
        }
    }
    
    func prepareForLaunch() {
        if UserDefaults.standard.bool(forKey: "wereWelcomePagesShown") {
            verifyReceipt()
        } else {
            let welcomeVc = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
            mainWindow.rootViewController = welcomeVc
        }
    }
}
