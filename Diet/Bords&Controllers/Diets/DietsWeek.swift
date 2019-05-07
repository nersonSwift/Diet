//
//  DietsWeek.swift
//  Diet
//
//  Created by Александр Сенин on 20/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DietsWeek: UIViewController, NavigationProtocol {
    var sub: Bool! = true
    var navigation: Navigation!
    var diet: Diet?{
        didSet {
            DispatchQueue.main.async {
                self.seting()
            }
        }
    }
    var backButton: UIButtonP!
    var aninEnd = true
    let loadingVc = LoadingViewController()
    var blurEffectView: UIVisualEffectView!
    let fetchingQueue = DispatchQueue.global(qos: .utility)
    var networkService = NetworkService()
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var cachedImage = NSCache<AnyObject, AnyObject>()
    var cellTapped: ((_ dish: Dish) -> Void)?
    var nameRas = ""
    var couter = 0
    var body: CategoryName!
    var weekColleticonsResipe: [ColletcionResipe] = []
    let weekName = ["Monday".localized,     "Tuesday".localized,
                    "Wednesday".localized,  "Thursday".localized,
                    "Friday".localized,     "Saturday".localized,
                    "Sunday".localized]
    var menue: UIView!
    let animator = UIViewPropertyAnimator(duration: 0.6, curve: .linear)
    var discrintion: [String: String] = ["\(CategoryName.severeObesity)": "Ration at 1000 kcal/daily is way for quick weight loss. Consume less calories than you spend.".localized,
                                         "\(CategoryName.obesity)": "Ration at 1200 kcal/daily for healthy weight loss and keeping yourself in good form. Eat systematically and you will get the result.".localized,
                                         "\(CategoryName.excessObesity)": "Ration at 1400 kcal/daily to maintain current form or calm weight loss. Full meals without a strong feeling of hunger.".localized,
                                         "\(CategoryName.normal)": "Ration at 2000 kcal/daily for those who lead an active lifestyle, play sports and at the same time want to be fit.".localized,
                                         "\(CategoryName.underweight)": "Ration at 2500 kcal/daily for those who are actively practise dtsports and want to gain muscle mass. Consume more calories than you spend.".localized]
   
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let dietsWeek = storyboard.instantiateInitialViewController() as? DietsWeek
        dietsWeek?.navigation = navigation
        return dietsWeek
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    func peremotka(){
        let toDay = Calendar.current.dateComponents([.weekday], from: Date())

        scrollView.scrollRectToVisible(CGRect(x: 0,
                                              y: weekColleticonsResipe[toDay.weekday! - 2].collectionView.center.y - view.frame.height / 2,
                                              width: view.frame.width,
                                              height: view.frame.height), animated: true)
        
    }
    
    func createView(){
        add(loadingVc)
        
        if scrollView != nil{
            scrollView.removeFromSuperview()
        }
        
        let scrollViewFrame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
        scrollView = UIScrollView(frame: scrollViewFrame)
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: view.frame.height * 2)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        if blurEffectView != nil{
            blurEffectView.removeFromSuperview()
        }
        blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = view.frame
        blurEffectView.isHidden = true
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(animMenuOff))
        tap.cancelsTouchesInView = false
        blurEffectView.addGestureRecognizer(tap)
        
        animator.addAnimations {
            self.blurEffectView.effect = UIBlurEffect(style: .regular)
        }
        
        animator.fractionComplete = 0.2
        
        if backButton != nil{
            backButton.removeFromSuperview()
        }
        
        let backButtonFrame = CGRect(x: view.frame.width * 0.015,
                                     y: view.frame.height * 0.04,
                                     width: view.frame.width * 0.05 * 2,
                                     height: (view.frame.width * 0.05) * 2)
        backButton = UIButtonP(frame: backButtonFrame)
        backButton.layer.contents = UIImage(named: "Hamburger")?.cgImage
        backButton.layer.shadowRadius = 3
        backButton.layer.shadowOpacity = 0.4
        backButton.layer.borderWidth = 0
        backButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backButton.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        backButton.addClosure(event: .touchUpInside){
            self.animMenuOn()
        }
        view.addSubview(backButton)
        
        let menueFrame = CGRect(x: view.frame.width * 0.015,
                                y: view.frame.height * 0.04,
                                width: view.frame.width * 0.7,
                                height: view.frame.width * 0.6)
        menue = UIView(frame: menueFrame)
        menue.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menue.layer.cornerRadius = view.frame.width / 15
        menue.layer.borderColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        menue.layer.borderWidth = 3
        menue.transform.tx = -view.frame.width
        view.addSubview(menue)
        
        let favoritButtonFrame = CGRect(x: menueFrame.width * 0.25,
                                        y: menueFrame.height / 2 - menueFrame.height / 6,
                                        width: menueFrame.width * 0.8,
                                        height: menueFrame.height / 3.5)
        let favoritButton = UIButtonP(frame: favoritButtonFrame)
        favoritButton.setTitle("Favorites".localized, for: .normal)
        favoritButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        favoritButton.contentHorizontalAlignment = .left
        favoritButton.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                                size: ((self.view.frame.height + self.view.frame.width) / 2) / 26)
        favoritButton.addClosure(event: .touchUpInside){
            self.navigation.transitionToView(viewControllerType: FavoritesView(), animated: true, special: nil)
            self.animMenuOff()
        }
        menue.addSubview(favoritButton)
        
        let profButtonIconFrame = CGRect(x: menueFrame.width * 0.05,
                                         y: 0,
                                         width: menueFrame.height / 8,
                                         height: menueFrame.height / 8)
        let favoritButtonIcon = UIImageView(frame: profButtonIconFrame)
        favoritButtonIcon.image = UIImage(named: "star (2)")
        favoritButtonIcon.center.y = favoritButton.center.y
        menue.addSubview(favoritButtonIcon)
        
        let profButtonFrame = CGRect(x: menueFrame.width * 0.25,
                                     y: favoritButtonFrame.minY - menueFrame.height / 3.5,
                                     width: menueFrame.width * 0.8,
                                     height: menueFrame.height / 3.5)
        let profButton = UIButtonP(frame: profButtonFrame)
        profButton.setTitle("My profile".localized, for: .normal)
        profButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        profButton.contentHorizontalAlignment = .left
        profButton.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                             size: ((self.view.frame.height + self.view.frame.width) / 2) / 26)
        profButton.addClosure(event: .touchUpInside){
            self.navigation.transitionToView(viewControllerType: ProfilView(), animated: true, special: nil)
            self.animMenuOff()
        }
        menue.addSubview(profButton)
        
        let profButtonIcon = UIImageView(frame: profButtonIconFrame)
        profButtonIcon.image = UIImage(named: "user")
        profButtonIcon.center.y = profButton.center.y
        menue.addSubview(profButtonIcon)
        
        let rasionButtonFrame = CGRect(x: menueFrame.width * 0.23,
                                       y: favoritButtonFrame.minY + menueFrame.height / 3.5,
                                       width: menueFrame.width * 0.8,
                                       height: menueFrame.height / 3.5)
        let rasionButton = UIButtonP(frame: rasionButtonFrame)
        rasionButton.setTitle("Сhange diet".localized, for: .normal)
        rasionButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        rasionButton.contentHorizontalAlignment = .left
        rasionButton.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0),
                                                size: ((self.view.frame.height + self.view.frame.width) / 2) / 26)
        rasionButton.addClosure(event: .touchUpInside){
            self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
            self.animMenuOff()
        }
        menue.addSubview(rasionButton)
        
        let rasionButtonIcon = UIImageView(frame: profButtonIconFrame)
        rasionButtonIcon.image = UIImage(named: "share")
        rasionButtonIcon.center.y = rasionButton.center.y
        menue.addSubview(rasionButtonIcon)
        
        let imageViewFrame = CGRect(x: 0,
                                    y: -20,
                                    width: view.frame.width,
                                    height: view.frame.width * 0.6)
        
        imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: navigation.realmData.userModel!.obesityTypeSelect + "1")
        scrollView.addSubview(imageView)
        networkService.dietServiceDelegate = self
        body = CategoryName(rawValue: navigation.realmData.userModel!.obesityTypeSelect)
        print(navigation.realmData.userModel!.obesityTypeSelect)
        switch body!{
        case .underweight:
            networkService.getDiet(.power)
            nameRas = DietType.power.description
        case .normal:
            networkService.getDiet(.balance)
            nameRas = DietType.balance.description
        case .excessObesity:
            networkService.getDiet(.daily)
            nameRas = DietType.daily.description
        case .obesity:
            networkService.getDiet(.fit)
            nameRas = DietType.fit.description
        case .severeObesity:
            networkService.getDiet(.superFit)
            nameRas = DietType.superFit.description
        case .undefined:
            networkService.getDiet(.balance)
        }
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
    
    func animMenuOn(){
        if !aninEnd{
            return
        }
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            self.aninEnd = false
            self.menue.transform.tx = 0
            self.blurEffectView.isHidden = false
            self.blurEffectView.alpha = 1
        }){(finished) -> Void in
            self.aninEnd = true
        }
    }
    
    @objc func animMenuOff(){
        if !aninEnd{
            return
        }
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations:{
            self.aninEnd = false
            self.menue.transform.tx = -self.view.frame.width
            self.blurEffectView.isHidden = true
            self.blurEffectView.alpha = 0
        }){(finished) -> Void in
            self.aninEnd = true
            self.blurEffectView.isHidden = true
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right: break
                //self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
            default: break
            }
        }
    }
    
    func seting(){
        
        let lableFoundationFrame = CGRect(x: view.frame.width * 0.015,
                                          y: imageView.frame.height - 50,
                                          width: view.frame.width * 0.97,
                                          height: 0)
        let lableFoundation = UIView(frame: lableFoundationFrame)
        lableFoundation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lableFoundation.layer.shadowRadius = 4
        lableFoundation.layer.shadowOpacity = 0.2
        lableFoundation.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        scrollView.addSubview(lableFoundation)
        
        let textLabelFrame = CGRect(x: lableFoundationFrame.width * 0.05,
                                    y: lableFoundationFrame.width * 0.05,
                                    width: lableFoundationFrame.width * 0.9,
                                    height: 0)
        let textLabel = UILabel(frame: textLabelFrame)
        textLabel.numberOfLines = 0
        textLabel.text = nameRas
        textLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 20)
        textLabel.sizeToFit()
        lableFoundation.addSubview(textLabel)
        
        let textFrame = CGRect(x: lableFoundationFrame.width * 0.05,
                               y: textLabel.frame.maxY + lableFoundationFrame.width * 0.07,
                               width: lableFoundationFrame.width * 0.9,
                               height: 0)
        let textDiscription = UILabel(frame: textFrame)
        textDiscription.numberOfLines = 0
        textDiscription.text = discrintion[navigation.realmData.userModel!.obesityTypeSelect]
        textDiscription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                                      size: ((self.view.frame.height + self.view.frame.width) / 2) / 28)
        textDiscription.sizeToFit()
        lableFoundation.addSubview(textDiscription)
        
        let toDayButtonFrame = CGRect(x: lableFoundationFrame.width * 0.05,
                                      y: textDiscription.frame.maxY + lableFoundationFrame.width * 0.05,
                                      width: lableFoundationFrame.width * 0.9,
                                      height: view.frame.height * 0.07)
        let toDayButton = UIButtonP(frame: toDayButtonFrame)
        toDayButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        toDayButton.layer.cornerRadius = toDayButton.frame.height / 5
        toDayButton.layer.shadowRadius = 4
        toDayButton.layer.shadowOpacity = 0.2
        toDayButton.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        toDayButton.setTitle("Recipes for today".localized, for: .normal)
        toDayButton.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                              size: ((view.frame.height + view.frame.width) / 2) / 25)
        toDayButton.addClosure(event: .touchUpInside){
            self.peremotka()
        }
        lableFoundation.addSubview(toDayButton)
        
        lableFoundation.frame = CGRect(x: lableFoundationFrame.minX,
                                       y: lableFoundationFrame.minY,
                                       width: lableFoundationFrame.width,
                                       height: toDayButton.frame.maxY + lableFoundationFrame.width * 0.05)
        lableFoundation.layer.cornerRadius = lableFoundation.frame.width / 14
        let heightCollectionView: CGFloat = 270.0
        for i in weekColleticonsResipe{
            i.collectionView.removeFromSuperview()
        }
        weekColleticonsResipe = []
        for i in 0...6{
            weekColleticonsResipe.append(ColletcionResipe(day: diet!.weeks.first!.days[i], view: view))
            let collectionView = weekColleticonsResipe[i].collectionView
            weekColleticonsResipe[i].cellTapped = { [weak self] (dish) in
                guard let self = self else { return }
                self.navigation.transitionToView(viewControllerType: RecipeView(), animated: true){ nextViewController in
                    let recipeView = nextViewController as! RecipeView
                    recipeView.recieve(dish: dish)
                }
            }
            scrollView.addSubview(collectionView!)
            
            let collectionViewFrame = CGRect(x: 0,
                                             y: (lableFoundation.frame.maxY + heightCollectionView * 0.2) + CGFloat(i) * (heightCollectionView * 1.2),
                                             width: view.frame.width,
                                             height: heightCollectionView)
            collectionView!.frame = collectionViewFrame
            
            
            let labelDayFrame = CGRect(x: lableFoundation.frame.minX,
                                       y: collectionViewFrame.minY - heightCollectionView * 0.2,
                                       width: lableFoundation.frame.width,
                                       height: heightCollectionView * 0.2)
            let labelDay = UILabel(frame: labelDayFrame)
            labelDay.font = UIFont(descriptor: UIFontDescriptor(name: "AvenirNext-DemiBold", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 25)
            labelDay.text = weekName[i]
            scrollView.addSubview(labelDay)
            
            if i == 6{
                scrollView.contentSize = CGSize(width: view.frame.width, height: collectionView!.frame.maxY)
            }
        }
        loadingVc.remove()
    }
    
}

extension DietsWeek: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -10{
            return
        }
        let h = (view.frame.width * 0.6) - scrollView.contentOffset.y
        let w = h * 1.6
        let imageViewFrame = CGRect(x: -(w - view.frame.width) / 2,
                                    y: scrollView.contentOffset.y,
                                    width: w,
                                    height: h)
        imageView.frame = imageViewFrame
    }
}

extension DietsWeek: DietNetworkServiceDelegate{
    func dietNetworkServiceDidGet(_ diet: Diet) {
        DispatchQueue.main.async {
            self.diet = diet
        }
    }
    
    func fetchingEndedWithError(_ error: Error) {}
    
}

