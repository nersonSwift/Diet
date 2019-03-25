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
    let loadingVc = LoadingViewController()
    let fetchingQueue = DispatchQueue.global(qos: .utility)
    var networkService = NetworkService()
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var cachedImage = NSCache<AnyObject, AnyObject>()
    var cellTapped: ((_ dish: Dish) -> Void)?
    var couter = 0
    var body: CategoryName!
    var weekColleticonsResipe: [ColletcionResipe] = []
    let weekName = ["Monday".localized,     "Tuesday".localized,
                    "Wednesday".localized,  "Thursday".localized,
                    "Friday".localized,     "Saturday".localized,
                    "Sunday".localized]
   
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let dietsWeek = storyboard.instantiateInitialViewController() as? DietsWeek
        dietsWeek?.navigation = navigation
        return dietsWeek
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(loadingVc)
        
        let scrollViewFrame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
        scrollView = UIScrollView(frame: scrollViewFrame)
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: view.frame.height * 2)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let backButtonFrame = CGRect(x: view.frame.width * 0.015,
                                     y: view.frame.height * 0.08,
                                     width: view.frame.width * 0.05,
                                     height: (view.frame.width * 0.05) * 1.7)
        let backButton = UIButtonP(frame: backButtonFrame)
        backButton.layer.contents = UIImage(named: "arrow")?.cgImage
        backButton.alpha = 0.7
        backButton.layer.shadowRadius = 3
        backButton.layer.shadowOpacity = 0.4
        backButton.layer.borderWidth = 0
        backButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backButton.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        backButton.addClosure(event: .touchUpInside){
            self.navigation.transitionToView(viewControllerType: SelectMenu(), animated: true, special: nil)
        }
        view.addSubview(backButton)
        
        let imageViewFrame = CGRect(x: 0,
                                    y: -20,
                                    width: view.frame.width,
                                    height: view.frame.width * 0.6)
        
        imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "back")
        scrollView.addSubview(imageView)
        networkService.dietServiceDelegate = self
        switch body!{
        case .underweight:
            networkService.getDiet(.power)
        case .normal:
            networkService.getDiet(.balance)
        case .excessObesity:
            networkService.getDiet(.daily)
        case .obesity:
            networkService.getDiet(.fit)
        case .severeObesity:
            networkService.getDiet(.superFit)
        case .undefined:
            networkService.getDiet(.balance)
        }
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
        textLabel.text = diet!.name
        textLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Medium", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 25)
        textLabel.sizeToFit()
        lableFoundation.addSubview(textLabel)
        
        let textFrame = CGRect(x: lableFoundationFrame.width * 0.05,
                               y: textLabel.frame.maxY + lableFoundationFrame.width * 0.07,
                               width: lableFoundationFrame.width * 0.9,
                               height: 0)
        let textDiscription = UILabel(frame: textFrame)
        textDiscription.numberOfLines = 0
        textDiscription.text = diet!.description
        textDiscription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 28)
        textDiscription.sizeToFit()
        lableFoundation.addSubview(textDiscription)
        
        lableFoundation.frame = CGRect(x: lableFoundationFrame.minX,
                                       y: lableFoundationFrame.minY,
                                       width: lableFoundationFrame.width,
                                       height: textDiscription.frame.maxY + lableFoundationFrame.width * 0.05)
        lableFoundation.layer.cornerRadius = lableFoundation.frame.width / 14
        let heightCollectionView: CGFloat = 270.0
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

