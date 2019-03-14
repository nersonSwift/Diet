//
//  WelcomePageViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    @IBOutlet weak var nextButtomBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var paperOnboardingView: PaperOnboarding!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate static let titleFont = UIFont(name: "Helvetica-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    fileprivate static let descriptionFont = UIFont(name: "Helvetica-Regular", size: 25.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "slim")!,
                           title: "Obesity index".localized,
                           description: "Find out your obesity index. Our app precisely calculates index just for you!".localized,
                           pageIcon: UIImage(named: "stretch")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "recipe")!,
                           title: "Test".localized,
                           description: "Take a simple test and we will do our best to help you with diets.".localized,
                           pageIcon: UIImage(named: "clipboard")!,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "chat")!,
                           title: "Stats".localized,
                           description: "Get statistics of your parameters during your diet.".localized,
                           pageIcon: UIImage(named: "chat_mini")!,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "diet")!,
                           title: "Result".localized,
                           description: "With our help you can rapidly lose weight. Get started right now!".localized,
                           pageIcon: UIImage(named: "ruler")!,
                           color: UIColor(red: 1, green: 126 / 255, blue: 121/255, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaperOnboardingView()
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
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if paperOnboardingView.currentIndex + 1 <= items.count - 1 {
            paperOnboardingView.currentIndex(paperOnboardingView.currentIndex + 1, animated: true)
        } else {
            UserDefaults.standard.set(true, forKey: "wereWelcomePagesShown")
            EventManager.sendEvent(with: "User saw welcome screen")
            
            if let nextViewController = TestPageView.storyboardInstance() {
                present(nextViewController, animated: true, completion: nil)
            }
        }
    }
}

extension WelcomePageViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonTo(index: Int) {
        
        if index == items.count - 1 {
           nextButton.setTitle("FINISH".localized, for: .normal)
            
        } else {
           nextButton.setTitle("NEXT".localized, for: .normal)
         }

        nextButtomBottomConstraint.constant = nextButton.frame.height
        nextButton.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: .curveEaseOut, animations: {
                        self.nextButtomBottomConstraint.constant = 87
                        self.nextButton.alpha = 0
                        self.nextButton.alpha = 1
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: PaperOnboardingDataSource
extension WelcomePageViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
}
