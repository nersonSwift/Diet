//
//  WelcomePageViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import AppsFlyerLib
import SwiftyStoreKit
import SafariServices

struct ModelMainView {
    var foundationView: UIView!
    var backView: UIView!
    var imageViewSelect: UIImageView!
    var titleView: UILabel!
    var descriptionView: UIView!
    var buttonNext: UIView!
    var colors: [UIColor]!
}

public struct OnboardingItemInfo {
    public let informationImage: UIImage
    public let title: String
    public var description: String
    public let colors: [UIColor]
    
    public init (informationImage: UIImage, title: String, description: String, colors: [UIColor]) {
        self.informationImage = informationImage
        self.title = title
        self.description = description
        self.colors = colors
    }
}

class Main: UIViewController, NavigationProtocol {
    var sub: Bool! = false
    var navigation: Navigation!
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let main = storyboard.instantiateInitialViewController() as? Main
        main!.navigation = navigation
        return main
    }
    var launchView: UIView!
    
    
    var counter = 0
    var anim = false
    
    var selectView: ModelMainView!
    var nextView: ModelMainView!
    
    var storegeBolls: UIView!
    var bolls: [UIView] = []
    var descriptionView: UILabel!
    var productId: ProductId! = .quarterly
    
    var infoView: InfoView!
    var infoView1: InfoView!
    
    fileprivate static let titleFont = UIFont(name: "Helvetica-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    fileprivate static let descriptionFont = UIFont(name: "Helvetica-Regular", size: 25.0) ?? UIFont.systemFont(ofSize: 14.0)
    fileprivate var items = [
        OnboardingItemInfo(informationImage: UIImage(named: "door")!,
                           title: "Welcome!".localized,
                           description: "Swipe left or tap on the button to learn about the main features of our application.".localized,
                           colors: [#colorLiteral(red: 0.5723839402, green: 0.2453544438, blue: 1, alpha: 1),#colorLiteral(red: 0.3374865055, green: 0.1396096647, blue: 0.6071564555, alpha: 1)]),
        
        OnboardingItemInfo(informationImage: UIImage(named: "imt")!,
                           title: "BMI & daily caloric intake".localized,
                           description: "We calculate your body mass index and tell about the condition of the body it signals.".localized,
                           colors: [#colorLiteral(red: 0.9999803901, green: 0.9894250035, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)]),
        
        OnboardingItemInfo(informationImage: UIImage(named: "rocion")!,
                           title: "Personal ration".localized,
                           description: "After the test is will be done, you will know your daily calorie intake and we will make the right diet plan.".localized,
                           colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]),
        
        OnboardingItemInfo(informationImage: UIImage(named: "resip")!,
                           title: "New recipes every week".localized,
                           description: "Every week we will send new recipes, turn on notifications to not miss them.".localized,
                           colors: [#colorLiteral(red: 0, green: 1, blue: 0.7865307927, alpha: 1),#colorLiteral(red: 0.3249981403, green: 0.5330184698, blue: 0.7418434024, alpha: 1)]),
                           
        OnboardingItemInfo(informationImage: UIImage(named: "starW")!,
                           title: "Your nutrition plan ready!".localized,
                           description: "",
                           colors: [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
                           
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingVC = LoadingViewController()
        loadingVC.view.backgroundColor = .lightGray
        launchView = loadingVC.view
        view.addSubview(launchView)
        
    }
    
    func start(){
        createstStoregeBolls()
        
        if UserDefaults.standard.bool(forKey: "checkSub"){
            counter = 4
        }
        
        resizeStorageBolls(namberView: counter - 1)
        strafeBolls(namberView: counter - 1)
        createSubInfo()
        selectView = createView(namberView: counter)
        presentView(modelMainView: selectView)
        addSwipe()
    }
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                if counter < 4 && !anim{
                    self.counter += 1
                    self.nextView = self.createView(namberView: counter)
                    self.animView(namberView: counter - 1)
                }
            case .right:
                if counter > 0 && !anim{
                    self.counter -= 1
                    self.nextView = self.createView(namberView: counter)
                    self.animView(namberView: counter - 1)
                }
            default: break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigation == nil{
            navigation = Navigation(viewController: self)
        }
    }
    
    func createView(namberView: Int) -> ModelMainView{
        let textEvent = "User saw welcome screen - \(self.counter + 1)"
        if !UserDefaults.standard.bool(forKey: textEvent){
            UserDefaults.standard.set(true, forKey: textEvent)
            EventManager.sendEvent(with: textEvent)
        }
        if counter == 4{
            UserDefaults.standard.set(true, forKey: "checkSub")
        }
        
        var modelMainView = ModelMainView()
        var foundationView = UIView(frame: view.frame)
        var disText: UILabel? = nil
        var buttonTermsAndService: UIButtonP?
        var privacyPolicy: UIButtonP?
        if namberView == 4{
            let scrollViewFrame = CGRect(x: 0,
                                         y: -20,
                                         width: view.frame.width,
                                         height: view.frame.height + 20)
            foundationView = UIScrollView(frame: scrollViewFrame)
            let scrollView = foundationView as! UIScrollView
            
            let disTextFrame = CGRect(x: view.frame.width * 0.06,
                                      y: view.frame.height * 0.93,
                                      width: view.frame.width * 0.88,
                                      height: 15)
            disText = UILabel(frame: disTextFrame)
            let sizeFont = ((self.view.frame.height + self.view.frame.width) / 2) / 35
            disText!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                   size: sizeFont)
            disText!.textAlignment = .justified
            disText!.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
            disText!.numberOfLines = 0
            disText!.alpha = 0
            disText!.text = "After a free trial period subscription renews automaticly unless canceled before the end of the trial. Payment will be charged to your iTunes Account at confirmation of purchase. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. Subscription auto-renewal may be turned off by going to the Account Settings after purchase. Any unused portion of a free trial will be forfeited when you purchase a subscription.".localized
            disText!.sizeToFit()
            scrollView.addSubview(disText!)
            
            let buttonTermsAndServiceFrame = CGRect(x: disText!.frame.minX,
                                                    y: disText!.frame.maxY + view.frame.height * 0.02,
                                                    width: view.frame.width * 0.35,
                                                    height: view.frame.width * 0.13)
            buttonTermsAndService = UIButtonP(frame: buttonTermsAndServiceFrame)
            buttonTermsAndService!.setTitle("Terms of Service", for: .normal)
            buttonTermsAndService!.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            buttonTermsAndService!.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            buttonTermsAndService!.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                                             size: sizeFont)
            buttonTermsAndService!.layer.cornerRadius = buttonTermsAndServiceFrame.width / 10
            buttonTermsAndService!.addClosure(event: .touchUpInside){
                guard let url = URL(string: "https://sfbtech.org/terms") else { return }
                let webView = SFSafariViewController(url: url)
                self.present(webView, animated: true, completion: nil)
            }
            scrollView.addSubview(buttonTermsAndService!)
            
            let privacyPolicyFrame = CGRect(x: disText!.frame.maxX - view.frame.width * 0.35,
                                            y: disText!.frame.maxY + view.frame.height * 0.02,
                                            width: view.frame.width * 0.35,
                                            height: view.frame.width * 0.13)
            privacyPolicy = UIButtonP(frame: privacyPolicyFrame)
            privacyPolicy!.setTitle("Privacy Policy", for: .normal)
            privacyPolicy!.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            privacyPolicy!.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            privacyPolicy!.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                                     size: sizeFont)
            privacyPolicy!.layer.cornerRadius = privacyPolicyFrame.width / 10
            privacyPolicy!.addClosure(event: .touchUpInside){
                guard let url = URL(string: "https://sfbtech.org/policy") else { return }
                let webView = SFSafariViewController(url: url)
                self.present(webView, animated: true, completion: nil)
            }
            scrollView.addSubview(privacyPolicy!)
            
            scrollView.contentSize = CGSize(width: view.frame.width,
                                            height: buttonTermsAndService!.frame.maxY + view.frame.height * 0.05)
            
            animText(view: disText!)
        }
        
        view.addSubview(foundationView)
        modelMainView.foundationView = foundationView
        
        let backView = UIView()
        backView.applyGradient(colours: items[namberView].colors)
        backView.layer.masksToBounds = true
        modelMainView.colors = items[namberView].colors
        foundationView.addSubview(backView)
        
        
        if let dis = disText{
            foundationView.bringSubviewToFront(dis)
            foundationView.bringSubviewToFront(buttonTermsAndService!)
            foundationView.bringSubviewToFront(privacyPolicy!)
        }
        
        modelMainView.backView = backView
        
        var imageViewSelectW = view.frame.width * 0.35
        var sizeFont = ((self.view.frame.height + self.view.frame.width) / 2) / 18
        var imageViewSelectH = imageViewSelectW * 1.4
        switch namberView {
        case 1:
            imageViewSelectW = view.frame.width * 0.4
            sizeFont *= 0.7
            imageViewSelectH = imageViewSelectW * 1.4
        case 2:
            imageViewSelectW = view.frame.width * 0.35
            sizeFont *= 0.9
            imageViewSelectH = imageViewSelectW * 1.4
        case 3:
            imageViewSelectW = view.frame.width * 0.45
            sizeFont *= 0.68
            imageViewSelectH = imageViewSelectW * 1.4
        case 4:
            imageViewSelectW = view.frame.width * 0.4
            imageViewSelectH = imageViewSelectW * 1.1
            sizeFont *= 0.8
            
        default:break
        }
        let imageViewSelectFrame = CGRect(x: view.center.x - (imageViewSelectW / 2),
                                          y: (view.center.y / 2) - (imageViewSelectH / 2) ,
                                          width: imageViewSelectW,
                                          height: imageViewSelectH)
        let imageViewSelect = UIImageView(frame: imageViewSelectFrame)
        imageViewSelect.transform.ty = view.frame.height * 0.07
        imageViewSelect.alpha = 0
        imageViewSelect.image = items[namberView].informationImage
        foundationView.addSubview(imageViewSelect)
        modelMainView.imageViewSelect = imageViewSelect
        
        let titleFrame = CGRect(x: 0,
                                y: view.center.y,
                                width: view.frame.width,
                                height: view.frame.height * 0.05)
        let titleView = UILabel(frame: titleFrame)
        titleView.transform.ty = view.frame.height * 0.05
        titleView.alpha = 0
        titleView.text = items[namberView].title
        titleView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if namberView == 4{
            titleView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        titleView.textAlignment = .center
        titleView.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0), size: sizeFont)
        titleView.sizeToFit()
        foundationView.addSubview(titleView)
        modelMainView.titleView = titleView
        
        let descriptionFoudationFrame = CGRect(x: view.frame.width * 0.04,
                                               y: titleFrame.maxY + view.frame.height * 0.04,
                                               width: view.frame.width * 0.92,
                                               height: view.frame.height * 0.15)
        let descriptionFoudation = UIView(frame: descriptionFoudationFrame)
        descriptionFoudation.transform.ty = view.frame.height * 0.04
        descriptionFoudation.alpha = 0
        
        let descriptionFrame = CGRect(x: 0,
                                      y: 0,
                                      width: descriptionFoudationFrame.width,
                                      height: descriptionFoudationFrame.height)
        descriptionView = UILabel(frame: descriptionFrame)
        descriptionView.text = items[namberView].description
        descriptionView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if namberView == 4{
            descriptionFoudation.addSubview(infoView)
            descriptionFoudation.addSubview(infoView1)
        }
        descriptionView.textAlignment = .center
        descriptionView.numberOfLines = 0
        descriptionView.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Medium", size: 0),
                                      size: ((self.view.frame.height + self.view.frame.width) / 2) / 29)
        descriptionFoudation.addSubview(descriptionView)
        foundationView.addSubview(descriptionFoudation)
        modelMainView.descriptionView = descriptionFoudation
        
        let buttonNextFrame = CGRect(x: view.frame.width * 0.09,
                                     y: descriptionFoudationFrame.maxY + view.frame.height * 0.06,
                                     width: view.frame.width * 0.82,
                                     height: view.frame.height * 0.09)
        let buttonNext = UIButtonP(frame: buttonNextFrame)
        buttonNext.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        buttonNext.layer.cornerRadius = buttonNextFrame.height / 5
        buttonNext.layer.shadowRadius = 4
        buttonNext.layer.shadowOpacity = 0.2
        buttonNext.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        let animB = AnimRingView(subView: buttonNext)
        animB.transform.ty = view.frame.height * 0.03
        animB.alpha = 0
        
        
        buttonNext.setTitle("Next".localized, for: .normal)
        if namberView == 4{
            buttonNext.setTitle("Start!".localized, for: .normal)
        }
        buttonNext.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                             size: ((self.view.frame.height + self.view.frame.width) / 2) / 25)
        buttonNext.addClosure(event: .touchDown){
            buttonNext.setTitleColor(buttonNext.titleLabel?.textColor.withAlphaComponent(0.5), for: .normal)
        }
        buttonNext.addClosure(event: .touchUpInside){
            buttonNext.setTitleColor(buttonNext.titleLabel?.textColor.withAlphaComponent(1), for: .normal)
            if self.anim{
                return
            }
            if self.counter < 4{
                self.counter += 1
                self.nextView = self.createView(namberView: self.counter)
                self.animView(namberView: self.counter - 1)
            }else{
                let textIvent = "User clicked button sub"
                if !UserDefaults.standard.bool(forKey: textIvent){
                    UserDefaults.standard.set(true, forKey: textIvent)
                    EventManager.sendEvent(with: textIvent)
                }
                let loadingVc = LoadingViewController()
                self.add(loadingVc)
                if self.navigation.subData.activeSub{
                    if UserDefaults.standard.bool(forKey: "testShown1"){
                        if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                            self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                        }else{
                            self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                        }
                    }else{
                        self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                    }
                    
                    if self.navigation.subData.activeTrial && (self.navigation.realmData.userModel.trial){
                        self.navigation.realmData.userModel.trial = false
                        EventManager.sendEvent(with: AFEventStartTrial)
                    }
                }else{
                    self.navigation.subData.goSub(productId: self.productId.rawValue){
                        loadingVc.remove()
                        if self.navigation.subData.activeSub{
                            if UserDefaults.standard.bool(forKey: "testShown1"){
                                if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                                    self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                                }else{
                                    self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                                }
                            }else{
                                self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                            }
                            
                            if self.navigation.subData.activeTrial && (self.navigation.realmData.userModel.trial){
                                self.navigation.realmData.userModel.trial = false
                                EventManager.sendEvent(with: AFEventStartTrial)
                            }
                            let textIvent = "\(self.productId!)"
                            if !UserDefaults.standard.bool(forKey: textIvent){
                                UserDefaults.standard.set(true, forKey: textIvent)
                                EventManager.sendEvent(with: textIvent)
                            }
                        }else{
                            let presentFrame = CGRect(x: self.view.frame.width,
                                                      y: self.view.frame.width * 0.2,
                                                      width: self.view.frame.width * 0.2,
                                                      height: self.view.frame.width * 0.18)
                            let present = UIView(frame: presentFrame)
                            present.layer.borderWidth = 2
                            present.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                            present.layer.cornerRadius = presentFrame.height / 7
                            present.layer.shadowRadius = 4
                            present.layer.shadowOpacity = 0.2
                            present.layer.shadowOffset = CGSize(width: 0, height: 4.0)
                            present.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                            foundationView.addSubview(present)
                            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                                present.frame.origin.x = self.view.frame.width * 0.82
                            }, completion: {_ in
                                let textIvent = "User saw a present"
                                if !UserDefaults.standard.bool(forKey: textIvent){
                                    UserDefaults.standard.set(true, forKey: textIvent)
                                    EventManager.sendEvent(with: textIvent)
                                }
                            })
                            
                            let buttonPresentFrame = CGRect(x: 0,
                                                            y: 0,
                                                            width: present.frame.width * 0.5,
                                                            height: present.frame.width * 0.5)
                            let buttonPresent = UIButtonP(frame: buttonPresentFrame)
                            buttonPresent.center.x = present.frame.width / 2
                            buttonPresent.center.y = present.frame.height / 2
                            buttonPresent.layer.contents = UIImage(named: "gift")?.cgImage
                            present.addSubview(buttonPresent)
                            buttonPresent.addClosure(event: .touchUpInside){
                                let textIvent = "User saw a special offer WEEK"
                                if !UserDefaults.standard.bool(forKey: textIvent){
                                    UserDefaults.standard.set(true, forKey: textIvent)
                                    EventManager.sendEvent(with: textIvent)
                                }
                                let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
                                blurEffectView.frame = self.view.frame
                                self.view.addSubview(blurEffectView)
                                
                                let scrollFound = UIScrollView(frame: self.view.frame)
                                self.view.addSubview(scrollFound)
                                scrollFound.contentSize = CGSize(width: self.view.frame.width,
                                                                 height: buttonTermsAndService!.frame.maxY + self.view.frame.height * 0.05)
                                
                                let infoViewFrame = CGRect(x: self.view.frame.width * 0.05,
                                                           y: 100,
                                                           width: self.view.frame.width * 0.90,
                                                           height: self.view.frame.width * 0.90 * 1.2)
                                let infoView = InfoImageView(frame: infoViewFrame,
                                                             lableText: "Please wait!".localized,
                                                             subLableText: "Before you go we have special offer for you".localized,
                                                             descriptionText: " \(self.navigation.subData.prises[.week]!) " + "/ WEEK".localized,
                                                             subDescriptionText: "This offer is available only once.".localized,
                                                             image: UIImage(named: "gift")!,
                                                             textButton: "CONTINUE".localized)
                                {
                                    let textIvent = "User clicked button sub WEEK"
                                    if !UserDefaults.standard.bool(forKey: textIvent){
                                        UserDefaults.standard.set(true, forKey: textIvent)
                                        EventManager.sendEvent(with: textIvent)
                                    }
                                    let loadingVc = LoadingViewController()
                                    self.add(loadingVc)
                                    if self.navigation.subData.activeSub{
                                        if UserDefaults.standard.bool(forKey: "testShown1"){
                                            if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                                                self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                                            }else{
                                                self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                                            }
                                        }else{
                                            self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                                        }
                                    }else{
                                        self.navigation.subData.goSub(productId: ProductId.week.rawValue){
                                            loadingVc.remove()
                                            if self.navigation.subData.activeSub{
                                                if UserDefaults.standard.bool(forKey: "testShown1"){
                                                    if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                                                        self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                                                    }else{
                                                        self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                                                    }
                                                }else{
                                                    self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                                                }
                                                
                                                let textIvent = "\(ProductId.week)"
                                                if !UserDefaults.standard.bool(forKey: textIvent){
                                                    UserDefaults.standard.set(true, forKey: textIvent)
                                                    EventManager.sendEvent(with: textIvent)
                                                }
                                            }
                                        }
                                    }
                                }
                                blurEffectView.alpha = 0
                                scrollFound.alpha = 0
                                UIView.animate(withDuration: 0.3){
                                    blurEffectView.alpha = 1
                                    scrollFound.alpha = 1
                                }
                                let buttonKFrame = CGRect(x: infoView.frame.width * 0.85,
                                                          y:  infoView.frame.width * 0.1,
                                                          width: infoView.frame.width * 0.05,
                                                          height: infoView.frame.width * 0.05)
                                let buttonK = UIButtonP(frame: buttonKFrame)
                                buttonK.layer.contents = UIImage(named: "k")?.cgImage
                                infoView.addSubview(buttonK)
                                buttonK.addClosure(event: .touchUpInside){
                                    UIView.animate(withDuration: 0.3, animations:{
                                        blurEffectView.alpha = 0
                                        scrollFound.alpha = 0
                                    }){_ in
                                        foundationView.addSubview(buttonTermsAndService!)
                                        foundationView.addSubview(privacyPolicy!)
                                        foundationView.addSubview(disText!)
                                        blurEffectView.removeFromSuperview()
                                        scrollFound.removeFromSuperview()
                                    }
                                }
                                
                                infoView.center = self.view.center
                                scrollFound.addSubview(infoView)
                                scrollFound.addSubview(buttonTermsAndService!)
                                scrollFound.addSubview(privacyPolicy!)
                                scrollFound.addSubview(disText!)
                            }
                            /*
                            let textIvent = "User saw a special offer"
                            if !UserDefaults.standard.bool(forKey: textIvent){
                                UserDefaults.standard.set(true, forKey: textIvent)
                                EventManager.sendEvent(with: textIvent)
                            }
                            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
                            blurEffectView.frame = self.view.frame
                            self.view.addSubview(blurEffectView)
                            
                            let scrollFound = UIScrollView(frame: self.view.frame)
                            self.view.addSubview(scrollFound)
                            scrollFound.contentSize = CGSize(width: self.view.frame.width,
                                                             height: buttonTermsAndService!.frame.maxY + self.view.frame.height * 0.05)
                            
                            let infoViewFrame = CGRect(x: self.view.frame.width * 0.05,
                                                       y: 100,
                                                       width: self.view.frame.width * 0.90,
                                                       height: self.view.frame.width * 0.90 * 1.2)
                            let infoView = InfoImageView(frame: infoViewFrame,
                                                         lableText: "Please wait!".localized,
                                                         subLableText: "Before you go we have special offer for you".localized,
                                                         descriptionText: "FREE FOR 7 DAYS".localized,
                                                         subDescriptionText: "\(self.navigation.subData.prises[.moonT]!)" + "/month after free period".localized,
                                                         image: UIImage(named: "gift")!,
                                                         textButton: "CONTINUE".localized)
                            {
                                let textIvent = "User clicked button sub++"
                                if !UserDefaults.standard.bool(forKey: textIvent){
                                    UserDefaults.standard.set(true, forKey: textIvent)
                                    EventManager.sendEvent(with: textIvent)
                                }
                                let loadingVc = LoadingViewController()
                                self.add(loadingVc)
                                if self.navigation.subData.activeSub{
                                    if UserDefaults.standard.bool(forKey: "testShown1"){
                                        if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                                            self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                                        }else{
                                            self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                                        }
                                    }else{
                                        self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                                    }
                                    
                                    if self.navigation.subData.activeTrial && (self.navigation.realmData.userModel.trial){
                                        self.navigation.realmData.userModel.trial = false
                                        EventManager.sendEvent(with: AFEventStartTrial)
                                        print("++")
                                        print(AFEventStartTrial)
                                        print("++")
                                    }
                                }else{
                                    self.navigation.subData.goSub(productId: ProductId.moonT.rawValue){
                                        loadingVc.remove()
                                        if self.navigation.subData.activeSub{
                                            if UserDefaults.standard.bool(forKey: "testShown1"){
                                                if self.navigation.realmData.userModel!.obesityTypeSelect == ""{
                                                    self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
                                                }else{
                                                    self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true, special: nil)
                                                }
                                            }else{
                                                self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
                                            }
                                            
                                            if self.navigation.subData.activeTrial && (self.navigation.realmData.userModel.trial){
                                                self.navigation.realmData.userModel.trial = false
                                                EventManager.sendEvent(with: AFEventStartTrial)
                                                EventManager.sendEvent(with: "Trial++")
                                                print("++")
                                                print(AFEventStartTrial)
                                                print("++")
                                            }
                                        }
                                    }
                                }
                            }
                            infoView.center = self.view.center
                            scrollFound.addSubview(infoView)
                            scrollFound.addSubview(buttonTermsAndService!)
                            scrollFound.addSubview(privacyPolicy!)
                            scrollFound.addSubview(disText!)
                             */
                        }
                    }
                }
            }
        }
        buttonNext.addClosure(event: .touchUpOutside){
            buttonNext.setTitleColor(buttonNext.titleLabel?.textColor.withAlphaComponent(1), for: .normal)
        }
        
        foundationView.addSubview(animB)
        modelMainView.buttonNext = animB
        
        let selectBollFrame = storegeBolls.subviews[namberView].frame
        backView.frame = CGRect(x: storegeBolls.frame.minX + selectBollFrame.midX,
                                y: storegeBolls.frame.minY + selectBollFrame.midY,
                                width: 0,
                                height: 0)
        backView.layer.cornerRadius = backView.frame.width / 2
        backView.frame = CGRect(x: storegeBolls.frame.minX + selectBollFrame.midX,
                                y: storegeBolls.frame.minY + selectBollFrame.midY,
                                width: 0,
                                height: 0)
        backView.layer.cornerRadius = backView.frame.width / 2
        
        return modelMainView
    }
    
    func createSubInfo(){
        let descriptionFoudationFrame = CGRect(x: view.frame.width * 0.04,
                                               y: view.center.y + view.frame.height * 0.05 + view.frame.height * 0.04,
                                               width: view.frame.width * 0.92,
                                               height: view.frame.height * 0.15)
        let infoViewFrame = CGRect(x: 0,
                                   y: (descriptionFoudationFrame.height / 2) - (view.frame.width * 0.44 * 0.65) / 2,
                                   width: view.frame.width * 0.44,
                                   height: view.frame.width * 0.44 * 0.65)
        infoView = InfoView(frame: infoViewFrame,
                            lableText: "3 day trial".localized,
                            subLableText: "$3.75 / неделя".localized,
                            descriptionText: self.navigation.subData.prises[.moon]! + "/ month".localized,
                            subDescriptionText: "after free 3-day trial period".localized)
        
        let infoView1Frame = CGRect(x: view.frame.width * 0.92 - view.frame.width * 0.44,
                                    y: (descriptionFoudationFrame.height / 2) - (view.frame.width * 0.44 * 0.65) / 2,
                                    width: view.frame.width * 0.44,
                                    height: view.frame.width * 0.44 * 0.65)
        infoView1 = InfoView(frame: infoView1Frame,
                             lableText: "Quarterly".localized,
                             subLableText: "$2.50 / неделя".localized,
                             descriptionText: self.navigation.subData.prises[.quarterly]! + "/ quarter".localized,
                             subDescriptionText: "billed every 3th month".localized)
        infoView1.createDopView(textDopView: "SAVE 33.3%".localized)
        infoView1.active = true
        
        let infoViewButtonFrame = CGRect(x: 0,
                                         y: 0,
                                         width: view.frame.width * 0.44,
                                         height: view.frame.width * 0.44 * 0.65)
        let infoViewButton = UIButtonP(frame: infoViewButtonFrame)
        infoViewButton.addClosure(event: .touchUpInside){
            self.infoView.active = true
            self.infoView1.active = false
            self.productId = .moon
        }
        infoView.addSubview(infoViewButton)
        
        let infoView1Button = UIButtonP(frame: infoViewButtonFrame)
        infoView1Button.addClosure(event: .touchUpInside){
            self.infoView1.active = true
            self.infoView.active = false
            self.productId = .quarterly
        }
        infoView1.addSubview(infoView1Button)
                DispatchQueue.main.async {
                    var prise = ""
                    var valut = ""
                    for a in self.navigation.subData.prises[.moon]!{
                        if (Int("\(a)") != nil){
                            prise += "\(a)"
                        }else if a == ","{
                            prise += "."
                        }else if a != Character(" "){
                            valut += "\(a)"
                        }
                        
                    }
                    var format = "%@\(valut)"
                    let weekPrise = (Float(prise) ?? 0) / 4.0
                    prise = prise.filter({ (a) in a != Character(".")})
                    if String(format: format, prise) != self.navigation.subData.prises[.moon]!.filter({ (a) in (a != Character(" ")) && (a != Character(","))}){
                        format = "\(valut)%@"
                    }
                    self.infoView.infoSubLable.text = String(format: format, String(format:"%.2f", weekPrise)) + "/ week".localized
                    self.infoView.infoSubLable.sizeToFit()
                }
        
                DispatchQueue.main.async {
                    var prise = ""
                    var valut = ""
                    for a in self.navigation.subData.prises[.quarterly]!{
                        if (Int("\(a)") != nil){
                            prise += "\(a)"
                        }else if a == ","{
                            prise += "."
                        }else if a != Character(" "){
                            valut += "\(a)"
                        }
                        
                    }
                    var format = "%@\(valut)"
                    let weekPrise = (Float(prise) ?? 0) / 12.0
                    prise = prise.filter({ (a) in a != Character(".")})
                    if String(format: format, prise) != self.navigation.subData.prises[.quarterly]!.filter({ (a) in (a != Character(" ")) && (a != Character(","))}){
                        format = "\(valut)%@"
                    }
                    self.infoView1.infoSubLable.text = String(format: format, String(format:"%.2f", weekPrise)) + "/ week".localized
                    self.infoView1.infoSubLable.sizeToFit()
                }
        
        
    }
    
    func createstStoregeBolls(){
        let bollSizeS = (view.frame.height + view.frame.width) / 2 * 0.022
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        
        let storegeBollsFrame = CGRect(x: view.center.x - ((view.frame.width * 0.3) / 8),
                                       y: view.frame.height * 0.94,
                                       width: view.frame.width * 0.3,
                                       height: bollSizeL)
        storegeBolls = UIView(frame: storegeBollsFrame)
        view.addSubview(storegeBolls)
        
        for i in 0...4{
            let bollFrame = CGRect(x: ((storegeBollsFrame.width / 8) - bollSizeS / 2) + (storegeBollsFrame.width / 4) * CGFloat(i),
                                   y: (bollSizeL / 2) - (bollSizeS / 2),
                                   width: bollSizeS,
                                   height: bollSizeS)
            let boll = UIView(frame: bollFrame)
            boll.layer.cornerRadius = bollSizeS / 2
            boll.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            storegeBolls.addSubview(boll)
            bolls.append(boll)
        }
    }
    
    func animView(namberView: Int){
        anim = true
        UIView.animate(withDuration: 0.6, animations: {
            self.presentView(modelMainView: self.nextView)
            self.hideView(modelMainView: self.selectView)
            self.resizeStorageBolls(namberView: namberView)
        }){ _ in
            self.selectView.foundationView.removeFromSuperview()
            self.selectView = self.nextView
            self.anim = false
        }
        UIView.animate(withDuration: 0.7){
            self.strafeBolls(namberView: namberView)
        }
        
    }
    func animText(view: UIView){
        UIView.animate(withDuration: 0.6, animations: {
            view.alpha = 1
        })
    }
    
    func strafeBolls(namberView: Int){
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        
        let cell = view.frame.width * 0.3
        
        let storegeBollsFrame = CGRect(x: (view.center.x - (cell / 8)) - ((cell / 4) * CGFloat(namberView + 1)),
                                       y: view.frame.height * 0.94,
                                       width: view.frame.width * 0.3,
                                       height: bollSizeL)
        storegeBolls.frame = storegeBollsFrame
        if namberView == 3{
            for i in bolls{
                i.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    func resizeStorageBolls(namberView: Int){
        let bollSizeS = (view.frame.height + view.frame.width) / 2 * 0.022
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        let storegeBollsWidth = view.frame.width * 0.3
        
        for i in 0...4{
            let boll = bolls[i]
            var bollFrame = CGRect(x: ((storegeBollsWidth / 8) - bollSizeS / 2) + (storegeBollsWidth / 4) * CGFloat(i),
                                   y: (bollSizeL / 2) - (bollSizeS / 2),
                                   width: bollSizeS,
                                   height: bollSizeS)
            
            boll.layer.cornerRadius = bollSizeS / 2
            if i == namberView + 1{
                bollFrame = CGRect(x: ((storegeBollsWidth / 8) - bollSizeL / 2) + (storegeBollsWidth / 4) * CGFloat(i),
                                   y: 0,
                                   width: bollSizeL,
                                   height: bollSizeL)
                boll.layer.cornerRadius = bollSizeL / 2
            }
            boll.frame = bollFrame
            boll.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            storegeBolls.addSubview(boll)
        }
    }
    
    
    func presentView(modelMainView: ModelMainView){
        modelMainView.backView.frame = CGRect(x: -(view.frame.height * 2 - view.frame.width) / 2 ,
                                              y: -view.frame.height / 2,
                                              width: view.frame.height * 2,
                                              height: view.frame.height * 2)
        modelMainView.backView.layer.cornerRadius = modelMainView.backView.frame.height / 2
        modelMainView.backView.applyGradient(colours: modelMainView.colors)
        
        modelMainView.imageViewSelect.alpha = 1
        modelMainView.imageViewSelect.transform.ty = 0
        
        modelMainView.titleView.alpha = 1
        modelMainView.titleView.transform.ty = 0
        
        modelMainView.descriptionView.alpha = 1
        modelMainView.descriptionView.transform.ty = 0
        
        modelMainView.buttonNext.alpha = 1
        modelMainView.buttonNext.transform.ty = 0
        
        if modelMainView.backView.backgroundColor != #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
            view.bringSubviewToFront(storegeBolls)
        }
    }
    
    func hideView(modelMainView: ModelMainView){
        modelMainView.imageViewSelect.alpha = 0
        modelMainView.imageViewSelect.frame = CGRect(x: modelMainView.imageViewSelect.frame.minX,
                                                     y: (modelMainView.imageViewSelect.frame.minY - view.frame.height * 0.05),
                                                     width: modelMainView.imageViewSelect.frame.width,
                                                     height: modelMainView.imageViewSelect.frame.height)
        
        modelMainView.titleView.alpha = 0
        modelMainView.titleView.transform.ty = -(view.frame.height * 0.05)
        
        modelMainView.descriptionView.alpha = 0
        modelMainView.descriptionView.transform.ty = -(view.frame.height * 0.05)
        
        modelMainView.buttonNext.alpha = 0
        modelMainView.buttonNext.transform.ty = -(view.frame.height * 0.05)
    }

}
