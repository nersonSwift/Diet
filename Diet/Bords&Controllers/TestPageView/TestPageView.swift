//
//  TestPageViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import UserNotifications

protocol TestResultOutput: class {
    
    func testCompleted(with result: TestResult)
}

class TestPageView: UIPageViewController, NavigationProtocol {
    var navigation: Navigation!
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let testPageView = storyboard.instantiateInitialViewController() as? TestPageView
        testPageView?.navigation = navigation
        return testPageView
    }
    
    var testPages = [UIViewController]()
    var testViewData = [TestViewData]()
    var testResult = TestResult()
    weak var testOutput: TestResultOutput?
    var currentImagePosition: CGFloat = 0.0
    
    let genderSelectionPage = GenderSelectorViewController.controllerInStoryboard(UIStoryboard(name: "GenderSelectorViewController", bundle: nil))
    let ageSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let currentWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let goalWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let heightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    weak var currentViewController: UIViewController!
    
    let ageSelectionPageData = TestViewData(title: "Select your age".localized,
                                            iconName: "tomato", pickerData: (10,99))
    let currentWeightSelectionPageData = TestViewData(title: "Select your weight".localized,
                                                      iconName: "pear", pickerData: (50,150), unit: "kg".localized)
    let goalWeightSelectionPageData = TestViewData(title: "How much do you want to lose in weight".localized,
                                                   iconName: "starfruit", pickerData: (1,100), unit: "kg".localized)
    let heigthSelectionPageData = TestViewData(title: "Select your height".localized,
                                               iconName: "pomegranade", pickerData: (140,200), unit: "cm.".localized)
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "wereWelcomePagesShown")
        self.view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        fillPages()
        fillViewData()
        setViewControllers([testPages.first!], direction: .forward, animated: true, completion: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (isAllowed, error) in
            if isAllowed {
                self.setupLocalNotifications()
            } else {
                print("Permission has not been granted")
            }
        }
    }
    
    private func setupLocalNotifications() {
        
        var dateComponents = DateComponents()
        
        // monday
        dateComponents.weekday = 2
        dateComponents.hour = 12
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "New recipes!".localized
        notificationContent.body = "Check out new recipes".localized
        notificationContent.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "NEW_DIET", content: notificationContent, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let vc = currentViewController as? SelectingViewController {
            currentImagePosition = vc.foodImageView.frame.origin.x
        }
        setupSelectionTestPages()
    }
    
    fileprivate func fillViewData() {
        
        testViewData.append(ageSelectionPageData)
        testViewData.append(currentWeightSelectionPageData)
        testViewData.append(goalWeightSelectionPageData)
        testViewData.append(heigthSelectionPageData)
    }
    
    fileprivate func fillPages() {
        
        testPages.append(genderSelectionPage)
        testPages.append(ageSelectionPage)
        testPages.append(currentWeightSelectionPage)
        testPages.append(goalWeightSelectionPage)
        testPages.append(heightSelectionPage)
    }
    
    fileprivate func setupSelectionTestPages() {
        
        ageSelectionPage.testViewData = ageSelectionPageData
        currentWeightSelectionPage.testViewData = currentWeightSelectionPageData
        goalWeightSelectionPage.testViewData = goalWeightSelectionPageData
        heightSelectionPage.testViewData = heigthSelectionPageData
        
        let _ = ageSelectionPage.view
        let _ = heightSelectionPage.view
        let _ = goalWeightSelectionPage.view
        let _ = currentWeightSelectionPage.view
        
        handleBackButtonPressing()
        handleNextButtonPressing()
        heightSelectionPage.nextButton.setTitle("Finish".localized, for: .normal)
    }
    
    fileprivate func handleNextButtonPressing() {
        
        genderSelectionPage.genderSelected = { [unowned self] gender in
            self.testResult.gender = gender
            self.scrollToNextViewController()
        }
        
        ageSelectionPage.nextButtonPressed = { [unowned self] index in
            self.scrollToNextViewController()
            self.testResult.age = self.ageSelectionPageData.pickerData[index]
        }
        
        currentWeightSelectionPage.nextButtonPressed = { [unowned self] index in
            self.scrollToNextViewController()
            self.testResult.currentWeight = self.currentWeightSelectionPageData.pickerData[index]
        }
        
        goalWeightSelectionPage.nextButtonPressed = { [unowned self] index in
            
            if self.testResult.currentWeight <= self.goalWeightSelectionPageData.pickerData[index] {
                let alert = UIAlertController(title: "Error".localized, message: "You cant set goal bigger then your current weight".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.scrollToNextViewController()
                self.testResult.goalWeight = self.goalWeightSelectionPageData.pickerData[index]
            }
        }
        
        heightSelectionPage.nextButtonPressed = { [unowned self] index in
            self.navigation.transitionToView(viewControllerType: TestResultsView(), animated: true){ nextViewController in
                self.testResult.height = self.heigthSelectionPageData.pickerData[index]
                self.testOutput = nextViewController as! TestResultsView
                let _ = nextViewController.view
                self.testOutput?.testCompleted(with: self.testResult)
                self.setViewControllers([self.testPages.first!], direction: .forward, animated: false, completion: nil)
            }
        }
    }
    
    fileprivate func handleBackButtonPressing() {
        
        ageSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        currentWeightSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        goalWeightSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        heightSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
    }
    
    fileprivate func setupGenderSelectionPage(_ page: UIViewController) {
        
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = testPages.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = testPages[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    func scrollToPreviousViewController() {
        if let visibleViewController = viewControllers?.last,
            let previousViewContoller = pageViewController(self, viewControllerBefore: visibleViewController) {
            scrollToViewController(viewController: previousViewContoller, direction: .reverse)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension TestPageView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = testPages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard testPages.count > previousIndex else { return nil }
        currentViewController = testPages[viewControllerIndex]
        
        if let previousTestPage = testPages[previousIndex] as? SelectingViewController {
            previousTestPage.stepNumber = previousIndex
            previousTestPage.isReversed = true
            return previousTestPage
        }
        
        if let previousTestPage = testPages[previousIndex] as? GenderSelectorViewController {
            return previousTestPage
        }
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = testPages.index(of: viewController) else { return nil }
        currentViewController = testPages[viewControllerIndex]
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < testPages.count else { return nil }
        guard testPages.count > nextIndex else { return nil }
        
        if let nextTestPage = testPages[nextIndex] as? SelectingViewController {
            nextTestPage.stepLabel.text = "Step ".localized + "\(nextIndex + 1)" + " of 5".localized
            nextTestPage.isReversed = false
            return nextTestPage
        }
        
        if let nextTestPage = testPages[nextIndex] as? GenderSelectorViewController {
            //nextTestPage.isReversed = false
            return nextTestPage
        }
        return UIViewController()
    }
}
