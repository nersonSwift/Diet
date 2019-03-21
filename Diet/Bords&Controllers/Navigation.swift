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
    let realmData = RealmData()
    let subData = SubData()
    
    var controllers: [UIViewController] = []
    var selectView: UIViewController{
        return controllers.last!
    }
    
    init(viewController: UIViewController) {
        
        controllers.append(viewController)
        let main = controllers[0] as! Main
        let launchView = main.launchView
        if UserDefaults.standard.bool(forKey: "wereWelcomePagesShown"){
            if UserDefaults.standard.bool(forKey: "testShown"){
                subData.refrash(){
                    
                    if self.subData.activeSub{
                        self.transitionToView(viewControllerType: DietsWeek(), animated: false, completion: { nextViewController in
                            launchView?.removeFromSuperview()
                        }, special: nil)
                    }else{
                        self.transitionToView(viewControllerType: TestResultsView(), animated: false, special: nil)
                        self.transitionToView(viewControllerType: SubscriptionOfferView(), animated: false, completion: { nextViewController in
                            launchView?.removeFromSuperview()
                        }, special: nil)
                    }
                }
            }else{
                transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: false, completion: { nextViewController in
                    launchView?.removeFromSuperview()
                }, special: nil)
            }
        }else{
            launchView?.removeFromSuperview()
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
