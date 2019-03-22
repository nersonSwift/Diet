//
//  TestResultsViewController.swift
//  Diet
//
//  Created by Даниил on 22/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import CoreData

class TestResultsView: UIViewController, NavigationProtocol {
    var sub: Bool! = false
    var navigation: Navigation!
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let testResultsView = storyboard.instantiateInitialViewController() as? TestResultsView
        testResultsView?.navigation = navigation
        return testResultsView
    }

    @IBOutlet weak var genderIconImageView: UIImageView!
    @IBOutlet weak var genderTitleLabel: TestResultLabel!
    @IBOutlet weak var currentWeightTitleLable: TestResultLabel!
    @IBOutlet weak var ageTitleLabel: TestResultLabel!
    @IBOutlet weak var timeTitleLabel: TestResultLabel!
    @IBOutlet weak var agreedWithTestButton: UIButton!
    @IBOutlet weak var takeTestAgainButton: UIButton!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var heightTitle: UILabel!
    @IBOutlet weak var genderTitle: UILabel!
    
    var repeatTest: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "testShown")
        setAlpha(0)
        takeTestAgainButton.layer.borderWidth = 1
        takeTestAgainButton.layer.borderColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1).cgColor
        takeTestAgainButton.layer.cornerRadius = 15
        agreedWithTestButton.layer.cornerRadius = 15
        applyShadow(on: takeTestAgainButton.layer)
        applyCustomStyleToLabel(label: ageTitleLabel)
        applyCustomStyleToLabel(label: timeTitleLabel)
        applyCustomStyleToLabel(label: currentWeightTitleLable)
        print(currentWeightTitleLable)
        testCompleted()
    }
    
    func applyCustomStyleToLabel(label: UILabel) {
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1).cgColor
        label.layer.borderWidth = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.takeTestAgainButton.alpha = 1
            self.agreedWithTestButton.alpha = 1
            self.genderIconImageView.alpha = 1
            self.genderTitleLabel.alpha = 1
            self.genderTitle.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.ageTitleLabel.alpha = 1
            self.ageTitle.alpha = 1

        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.currentWeightTitleLable.alpha = 1
            self.weightTitle.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.4, options: [.curveEaseInOut], animations: {
            self.timeTitleLabel.alpha = 1
            self.heightTitle.alpha = 1
        }, completion: nil)
    }
    
    private func setAlpha(_ alpha: CGFloat) {
        
        timeTitleLabel.alpha = alpha
        ageTitleLabel.alpha = alpha
        currentWeightTitleLable.alpha = alpha
        heightTitle.alpha = alpha
        ageTitle.alpha = alpha
        weightTitle.alpha = alpha
        agreedWithTestButton.alpha = alpha
        takeTestAgainButton.alpha = alpha
        genderTitleLabel.alpha = alpha
        genderIconImageView.alpha = alpha
        genderTitle.alpha = alpha
    }
    
    fileprivate func showRetryableErrorAlert(with message: String, retryAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Try again".localized, style: .default) { (action) in
            retryAction()
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getFatnessCategory(index: Double, age: Int) -> CategoryName {
        
        if age <= 25{
            switch (index) {
            case(0...18.5):
                return CategoryName.underweight
            case(19.5...22.9):
                return CategoryName.normal
            case(23.0...27.4):
                return CategoryName.excessObesity
            case(27.5...29.9):
                return CategoryName.obesity
            case(30.0...100):
                return CategoryName.severeObesity
            default:
                return CategoryName.undefined
            }
        }else{
            switch(index) {
            case (0...19.9):
                return CategoryName.underweight
            case (20.0...25.9):
                return CategoryName.normal
            case (26.0...27.9):
                return CategoryName.excessObesity
            case(28.0...30.9):
                return CategoryName.obesity
            case(31...100.0):
                return CategoryName.severeObesity
            default:
                return CategoryName.undefined
            }
        }
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    fileprivate func calculateFatIndex(currentWeight: Int, height: Int) -> Double {
        
        var index = 0.0
        let heightFraction = Double(height) / 100.0
        let unroundedIndex = Double(currentWeight) / (heightFraction * heightFraction)
        index = unroundedIndex.rounded(toPlaces: 1)
        return index
    }
    
    @IBAction func agreedWithTestButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasUserPassedTest")
        EventManager.sendEvent(with: "User agreed with test results")
        navigation.transitionToView(viewControllerType: FatnessIndexView(), animated: true, special: nil)
    }
    
    @IBAction func takeTestAgainButtonPressed(_ sender: Any) {
        self.repeatTest?()
        navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
    }
}

extension TestResultsView: TestResultOutput {
    
    
    func testCompleted() {
        
        let userModel = navigation.realmData.userModel!
        var gender = Gender.male
        if userModel.gender{
            gender = .female
        }
        if currentWeightTitleLable != nil{
            currentWeightTitleLable.text = "\(userModel.currentWeight) " + "kg".localized
            timeTitleLabel.text = "\(userModel.height) " + "cm.".localized
            ageTitleLabel.text = "\(userModel.age)"
            genderTitleLabel.text = gender.description
            if gender == .male {
                genderIconImageView.image = UIImage(named: "male_icon")
            } else {
                genderIconImageView.image = UIImage(named: "female_icon")
            }
            let index = Double(Float(userModel.currentWeight) / ((Float(userModel.height) / 100) * (Float(userModel.height) / 100)))
            userModel.obesityType = getFatnessCategory(index: index, age: userModel.age).rawValue
        }
    }
}
