//
//  Navigation.swift
//  AlarmClock
//
//  Created by Александр Сенин on 22/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class Navigation{
    var controllers: [UIViewController] = []
    var selectView: UIViewController{
        return controllers.last!
    }
    
    init(viewController: UIViewController) {
        controllers.append(viewController)
        let main = controllers[0] as! Main
        let launchViewSecond = main.launchView
        if UserDefaults.standard.bool(forKey: "wereWelcomePagesShown"){
            if UserDefaults.standard.bool(forKey: "testShown"){
                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "41b8fe92dbd9448ab3e06f3507b01371")
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] (result) in
                    
                    switch result {
                    case .success(let receipt):
                        
                        let verificationResult = SwiftyStoreKit.verifySubscriptions(productIds: [ProductId.popular.rawValue, ProductId.cheap.rawValue], inReceipt: receipt)
                        switch verificationResult {
                        case .purchased(let receiptItems):
                            
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
                            self!.transitionToView(viewControllerType: DietView(), animated: false, completion: { nextViewController in
                                launchViewSecond?.removeFromSuperview()
                            }, special: nil)
                            
                        default:
                            self!.transitionToView(viewControllerType: TestResultsView(), animated: false, special: nil)
                            self!.transitionToView(viewControllerType: SubscriptionOfferView(), animated: false, completion: { nextViewController in
                                launchViewSecond?.removeFromSuperview()
                            }, special: nil)
                        }
                    

                    case .error:
                        self!.transitionToView(viewControllerType: TestResultsView(), animated: false, special: nil)
                        self!.transitionToView(viewControllerType: SubscriptionOfferView(), animated: false, completion: { nextViewController in
                            launchViewSecond?.removeFromSuperview()
                        }, special: nil)
                    }
                }
            }else{
                transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: false, completion: { nextViewController in
                    launchViewSecond?.removeFromSuperview()
                }, special: nil)
            }
        }else{
            launchViewSecond?.removeFromSuperview()
        }
    }
    
    func transitionToView(viewControllerType: NavigationProtocol, animated: Bool, special: ((UIViewController) -> Void)?){
        transitionToView(viewControllerType: viewControllerType, animated: animated, completion: nil, special: special)
    }
    
    func transitionToView(viewControllerType: NavigationProtocol, animated: Bool, completion: ((UIViewController) -> Void)?, special: ((UIViewController) -> Void)?){
        
        for i in 0 ..< controllers.count{
            if type(of: viewControllerType) == type(of: controllers[i]) {
                controllers[i+1 ..< controllers.count] = []
                controllers[i].dismiss(animated: animated, completion: {
                    special?(self.controllers[i])
                })
                return
            }
        }
        
        if let nextViewController = type(of: viewControllerType).storyboardInstance(navigation: self) {
            special?(nextViewController)
            selectView.present(nextViewController, animated: animated){
                completion?(nextViewController)
            }
            controllers.append(nextViewController)
        }
    }
}
