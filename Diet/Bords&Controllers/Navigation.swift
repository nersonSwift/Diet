//
//  Navigation.swift
//  AlarmClock
//
//  Created by Александр Сенин on 22/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import Alamofire
import SwiftyJSON
import SafariServices

class Navigation{
    let realmData = RealmData()
    let subData = SubData()
    let ssil = "http://dietsforbuddies.com/NewApi/version.json"
    
    var controllers: [UIViewController] = []
    var selectView: UIViewController{
        return controllers.last!
    }
    
    init(viewController: UIViewController) {
        
        controllers.append(viewController)
        let main = controllers[0] as! Main
        var launchView = main.launchView
        main.anim = true
        //launchView?.removeFromSuperview()
        let _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
            if launchView == nil{
                return
            }
            launchView?.removeFromSuperview()
            launchView = nil
            main.anim = false
        }
        
        subData.refrash(){
            if self.subData.activeSub{
                if UserDefaults.standard.bool(forKey: "testShown1"){
                    
                    if self.realmData.userModel!.obesityTypeSelect == ""{
                        self.transitionToView(viewControllerType: SelectMenu(), animated: false, completion: { nextViewController in
                            launchView?.removeFromSuperview()
                            launchView = nil
                            main.anim = false
                        }, special: nil)
                    }else{
                        self.transitionToView(viewControllerType: DietsWeek(), animated: false, completion: { nextViewController in
                            launchView?.removeFromSuperview()
                            launchView = nil
                            main.anim = false
                        }, special: nil)
                    }
                }else{
                    self.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: false, completion: { nextViewController in
                        launchView?.removeFromSuperview()
                        launchView = nil
                        main.anim = false
                    }, special: nil)
                }
            }else{
                launchView?.removeFromSuperview()
                launchView = nil
                main.anim = false
            }
            self.checkVersoin()
        }
    }
    
    private func checkVersoin(){
        let queue = DispatchQueue.global(qos: .utility)
        request(ssil).response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { response in
            guard let responseValue = response.result.value else {return}
            let json = JSON(responseValue)
            if json["version"].string! != "2.1.5"{
                print(json["version"].string!)
                DispatchQueue.main.async {
                    if let a = self.selectView as? Main{
                        a.anim = true
                    }
                    let newView = UIView(frame: self.selectView.view.frame)
                    newView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    self.selectView.view.addSubview(newView)
                    
                    let blurEffectView = UIVisualEffectView(effect: nil)
                    blurEffectView.frame = newView.frame
                    blurEffectView.effect = UIBlurEffect(style: .regular)
                    newView.addSubview(blurEffectView)
                    
                    let natifFrame = CGRect(x: 0,
                                            y: 0,
                                            width: newView.frame.width * 0.8,
                                            height: newView.frame.width * 0.6)
                    let natif = UIView(frame: natifFrame)
                    natif.center = newView.center
                    natif.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    natif.layer.cornerRadius = natifFrame.width / 5
                    natif.layer.shadowRadius = 4
                    natif.layer.shadowOpacity = 0.2
                    natif.layer.shadowOffset = CGSize(width: 0, height: 4.0)
                    newView.addSubview(natif)
                    
                    let textAppFrame = CGRect(x: 0,
                                              y: natifFrame.width * 0.1,
                                              width: natifFrame.width * 0.9,
                                              height: 0)
                    let textApp = UILabel(frame: textAppFrame)
                    textApp.text = "Critical update released.\nPlease update the app.".localized
                    textApp.textColor = #colorLiteral(red: 0.09721875936, green: 0.09664844722, blue: 0.0976620093, alpha: 1)
                    textApp.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Medium", size: 0),
                                          size: ((blurEffectView.frame.height + blurEffectView.frame.width) / 2) / 28)
                    textApp.numberOfLines = 0
                    textApp.textAlignment = .center
                    textApp.sizeToFit()
                    textApp.center.x = natif.center.x - natif.frame.minX
                    natif.addSubview(textApp)
                    
                    let buttonFrame = CGRect(x: (natifFrame.width / 2) - (natifFrame.width * 0.4 / 2),
                                             y: natifFrame.height * 0.65,
                                             width: natifFrame.width * 0.4,
                                             height: natifFrame.height * 0.2)
                    let button = UIButtonP(frame: buttonFrame)
                    button.setTitle("OK", for: .normal)
                    button.setTitleColor(#colorLiteral(red: 0.2825991809, green: 0.3677995801, blue: 1, alpha: 1), for: .normal)
                    button.addClosure(event: .touchUpInside){
                        guard let url = URL(string: "https://itunes.apple.com/us/app/diet-diary/id1445711141?l=ru&ls=1&mt=8") else { return }
                        let webView = SFSafariViewController(url: url)
                        self.selectView.present(webView, animated: true, completion: nil)
                    }
                    textApp.center.y = button.frame.minY / 2
                    natif.addSubview(button)
                }
            }
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
    
    func back(animated: Bool, completion: ((UIViewController) -> Void)?, special: ((UIViewController) -> Void)?){
        transitionToView(viewControllerType: controllers[controllers.count - 2] as! NavigationProtocol,
                         animated: animated,
                         completion: completion,
                         special: special)
    }
}
