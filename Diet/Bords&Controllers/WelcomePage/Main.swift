//
//  WelcomePageViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

struct ModelMainView {
    var foundationView: UIView!
    var backView: UIView!
    var imageViewSelect: UIImageView!
    var titleView: UILabel!
    var descriptionView: UILabel!
    var buttonNext: UIButtonP!
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
    
    @IBOutlet weak var nextButtomBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var paperOnboardingView: PaperOnboarding!
    @IBOutlet weak var nextButton: UIButton!
    
    var counter = 0
    var anim = false
    
    var selectView: ModelMainView!
    var nextView: ModelMainView!
    
    var storegeBolls: UIView!
    var bolls: [UIView] = []
    
    
    fileprivate static let titleFont = UIFont(name: "Helvetica-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    fileprivate static let descriptionFont = UIFont(name: "Helvetica-Regular", size: 25.0) ?? UIFont.systemFont(ofSize: 14.0)
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "door")!,
                           title: "Welcome!".localized,
                           description: "Swipe left or tap on the button to learn about the main features of our application.".localized,
                           pageIcon: UIImage(named: "stretch")!,
                           color: #colorLiteral(red: 0, green: 0.7921568627, blue: 0.4549019608, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Main.titleFont, descriptionFont: Main.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "imt")!,
                           title: "BMI & daily caloric intake".localized,
                           description: "We calculate your body mass index and tell about the condition of the body it signals.".localized,
                           pageIcon: UIImage(named: "clipboard")!,
                           color: #colorLiteral(red: 0.007843137255, green: 0.5019607843, blue: 0.5647058824, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Main.titleFont, descriptionFont: Main.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "rocion")!,
                           title: "Personal ration".localized,
                           description: "After the test is will be done, you will know your daily calorie intake and we will make the right diet plan.".localized,
                           pageIcon: UIImage(named: "chat_mini")!,
                           color: #colorLiteral(red: 0.937254902, green: 0.4352941176, blue: 0.4235294118, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Main.titleFont, descriptionFont: Main.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "resip")!,
                           title: "New recipes every week".localized,
                           description: "Every week we will send new recipes, turn on notifications to not miss them.".localized,
                           pageIcon: UIImage(named: "resip")!,
                           color: #colorLiteral(red: 0.262745098, green: 0.5058823529, blue: 0.7568627451, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Main.titleFont, descriptionFont: Main.descriptionFont)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createstStoregeBolls()
        resizeStorageBolls(namberView: counter - 1)
        selectView = createView(namberView: counter)
        presentView(modelMainView: selectView)
        let loadingVC = LoadingViewController()
        loadingVC.view.backgroundColor = .lightGray
        launchView = loadingVC.view
        view.addSubview(launchView)
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
                if counter < 3 && !anim{
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
        navigation = Navigation(viewController: self)
    }
    
    func createView(namberView: Int) -> ModelMainView{
        var modelMainView = ModelMainView()
        let foundationView = UIView(frame: view.frame)
        view.addSubview(foundationView)
        modelMainView.foundationView = foundationView
        
        let backView = UIView()
        backView.backgroundColor = items[namberView].color
        foundationView.addSubview(backView)
        modelMainView.backView = backView
        
        var imageViewSelectW = view.frame.width * 0.35
        var sizeFont = ((self.view.frame.height + self.view.frame.width) / 2) / 18
        
        switch namberView {
        case 1:
            imageViewSelectW = view.frame.width * 0.40
            sizeFont *= 0.7
        case 2:
            imageViewSelectW = view.frame.width * 0.35
            sizeFont *= 0.9
        case 3:
            imageViewSelectW = view.frame.width * 0.45
            sizeFont *= 0.68
        default:break
        }
        let imageViewSelectH = imageViewSelectW * 1.4
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
        titleView.textAlignment = .center
        titleView.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0), size: sizeFont)
        foundationView.addSubview(titleView)
        modelMainView.titleView = titleView
        
        let descriptionFrame = CGRect(x: view.frame.width * 0.04,
                                      y: titleFrame.maxY + view.frame.height * 0.02,
                                      width: view.frame.width * 0.92,
                                      height: view.frame.height * 0.15)
        let descriptionView = UILabel(frame: descriptionFrame)
        descriptionView.transform.ty = view.frame.height * 0.04
        descriptionView.alpha = 0
        descriptionView.text = items[namberView].description
        descriptionView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        descriptionView.textAlignment = .center
        descriptionView.numberOfLines = 0
        descriptionView.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Medium", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 29)
        foundationView.addSubview(descriptionView)
        modelMainView.descriptionView = descriptionView
        
        let buttonNextFrame = CGRect(x: view.frame.width * 0.06,
                                     y: descriptionFrame.maxY + view.frame.height * 0.07,
                                     width: view.frame.width * 0.88,
                                     height: view.frame.height * 0.09)
        let buttonNext = UIButtonP(frame: buttonNextFrame)
        buttonNext.transform.ty = view.frame.height * 0.03
        buttonNext.alpha = 0
        buttonNext.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        buttonNext.setTitle("NEXT".localized, for: .normal)
        if namberView == 3{
            buttonNext.setTitle("Finish".localized, for: .normal)
        }
        buttonNext.layer.cornerRadius = buttonNextFrame.height / 5
        buttonNext.layer.shadowRadius = 4
        buttonNext.layer.shadowOpacity = 0.2
        buttonNext.layer.shadowOffset = CGSize(width: 0, height: 4.0)
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
            if self.counter < 3{
            self.counter += 1
            self.nextView = self.createView(namberView: self.counter)
            self.animView(namberView: self.counter - 1)
            }else{
                EventManager.sendEvent(with: "User saw welcome screen")
                self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
            }
        }
        buttonNext.addClosure(event: .touchUpOutside){
            buttonNext.setTitleColor(buttonNext.titleLabel?.textColor.withAlphaComponent(1), for: .normal)
        }
        foundationView.addSubview(buttonNext)
        modelMainView.buttonNext = buttonNext
        
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
    
    func createstStoregeBolls(){
        let bollSizeS = (view.frame.height + view.frame.width) / 2 * 0.022
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        
        let storegeBollsFrame = CGRect(x: view.center.x - ((view.frame.width * 0.3) / 8),
                                       y: view.frame.height * 0.94,
                                       width: view.frame.width * 0.3,
                                       height: bollSizeL)
        storegeBolls = UIView(frame: storegeBollsFrame)
        view.addSubview(storegeBolls)
        
        for i in 0...3{
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
    
    func strafeBolls(namberView: Int){
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        
        let cell = view.frame.width * 0.3
        
        let storegeBollsFrame = CGRect(x: (view.center.x - (cell / 8)) - ((cell / 4) * CGFloat(namberView + 1)),
                                       y: view.frame.height * 0.94,
                                       width: view.frame.width * 0.3,
                                       height: bollSizeL)
        storegeBolls.frame = storegeBollsFrame
    }
    
    func resizeStorageBolls(namberView: Int){
        let bollSizeS = (view.frame.height + view.frame.width) / 2 * 0.022
        let bollSizeL = (view.frame.height + view.frame.width) / 2 * 0.03
        let storegeBollsWidth = view.frame.width * 0.3
        
        for i in 0...3{
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
        
        
        modelMainView.imageViewSelect.alpha = 1
        modelMainView.imageViewSelect.transform.ty = 0
        
        modelMainView.titleView.alpha = 1
        modelMainView.titleView.transform.ty = 0
        
        modelMainView.descriptionView.alpha = 1
        modelMainView.descriptionView.transform.ty = 0
        
        modelMainView.buttonNext.alpha = 1
        modelMainView.buttonNext.transform.ty = 0
        
        view.bringSubviewToFront(storegeBolls)
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
    
    private func setupPaperOnboardingView() {
        
        paperOnboardingView.dataSource = self
        paperOnboardingView.delegate = self
        
        view.bringSubviewToFront(nextButton)
        nextButton.setTitle("NEXT".localized, for: .normal)
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: paperOnboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}
