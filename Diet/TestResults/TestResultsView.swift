//
//  TestResultsViewController.swift
//  Diet
//
//  Created by Даниил on 22/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import CoreData

class TestResultsView: UIViewController {

    @IBOutlet weak var genderIconImageView: UIImageView!
    @IBOutlet weak var genderTitleLabel: TestResultLabel!
    @IBOutlet weak var currentWeightTitleLable: TestResultLabel!
    @IBOutlet weak var ageTitleLabel: TestResultLabel!
    @IBOutlet weak var goalWeightTitleLabel: TestResultLabel!
    @IBOutlet weak var timeTitleLabel: TestResultLabel!
    @IBOutlet weak var agreedWithTestButton: UIButton!
    @IBOutlet weak var takeTestAgainButton: UIButton!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var heightTitle: UILabel!
    @IBOutlet weak var genderTitle: UILabel!
    
    static func storyboardInstance() -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let testResultsView = storyboard.instantiateInitialViewController() as? TestResultsView
        return testResultsView
    }
    
    var repeatTest: (() -> Void)?
    var results: TestResult? {
        didSet {
            
            if results != nil {
                
                let fatnessIndex = calculateFatIndex(currentWeight: results!.currentWeight, height: results!.height)
                
                switch(results!.age) {
                case (0...25):
                    results!.fatnessCategory = getFatnessCategoryNameForTeens(index: fatnessIndex)
                case (26...100):
                    results!.fatnessCategory = getFatnessCategoryForAdults(index: fatnessIndex)
                default:
                    results!.fatnessCategory = CategoryName.undefined
                }
                deleteAllData("Test")
                save()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlpha(0)
        takeTestAgainButton.layer.borderWidth = 1
        takeTestAgainButton.layer.borderColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1).cgColor
        takeTestAgainButton.layer.cornerRadius = 15
        agreedWithTestButton.layer.cornerRadius = 15
        applyShadow(on: takeTestAgainButton.layer)
        applyCustomStyleToLabel(label: ageTitleLabel)
        applyCustomStyleToLabel(label: goalWeightTitleLabel)
        applyCustomStyleToLabel(label: timeTitleLabel)
        applyCustomStyleToLabel(label: currentWeightTitleLable)
    }
    
    func applyCustomStyleToLabel(label: UILabel) {
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1).cgColor
        label.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard results == nil else {
            return
        }
        fetchTestResult()
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
            self.goalWeightTitleLabel.alpha = 1
            self.goalTitle.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.6, options: [.curveEaseInOut], animations: {
            self.timeTitleLabel.alpha = 1
            self.heightTitle.alpha = 1
        }, completion: nil)
    }
    
    private func setAlpha(_ alpha: CGFloat) {
        
        timeTitleLabel.alpha = alpha
        ageTitleLabel.alpha = alpha
        currentWeightTitleLable.alpha = alpha
        goalWeightTitleLabel.alpha = alpha
        heightTitle.alpha = alpha
        ageTitle.alpha = alpha
        goalTitle.alpha = alpha
        weightTitle.alpha = alpha
        agreedWithTestButton.alpha = alpha
        takeTestAgainButton.alpha = alpha
        genderTitleLabel.alpha = alpha
        genderIconImageView.alpha = alpha
        genderTitle.alpha = alpha
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toObesityIndex" {
            
            if let destinationVc = segue.destination as? FatnessIndexViewContoller {
                guard let testResults = self.results else { return }
                let fatnessIndex = calculateFatIndex(currentWeight: testResults.currentWeight, height: testResults.height)
                
                destinationVc.testResults = testResults
                destinationVc.fatnessIndex = fatnessIndex
            }
        }
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
    
    func deleteAllData(_ entity:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showRetryableErrorAlert(with: "Could not save test results".localized, retryAction: save)
            return
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                appDelegate.persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    private func save() {
        
        guard let results = self.results else {
            showRetryableErrorAlert(with: "Could not save test results".localized, retryAction: save)
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showRetryableErrorAlert(with: "Could not save test results".localized, retryAction: save)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
    
        guard let entity = NSEntityDescription.entity(forEntityName: "Test", in: managedContext) else {
            showRetryableErrorAlert(with: "Could not save test results".localized, retryAction: save)
            return
        }
        
        let testResult = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        testResult.setValue(Int16(results.age), forKey: "age")
        testResult.setValue(results.currentWeight, forKey: "currentWeight")
        testResult.setValue(results.goalWeight, forKey: "goal")
        testResult.setValue(results.height, forKey: "height")
    
        if results.gender == .female {
            testResult.setValue(0, forKey: "gender")
        } else {
            testResult.setValue(1, forKey: "gender")
        }
        
        testResult.setValue(results.fatnessCategory.rawValue, forKey: "obesityType")
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
            showRetryableErrorAlert(with: "Could not save test results".localized, retryAction: save)
        }
    }
    
    private func fetchTestResult() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showRetryableErrorAlert(with: "Could not load test results".localized, retryAction: fetchTestResult)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Test", in: managedContext)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Test")
        fetchRequest.entity = entityDescription
        
        do {
            if let testResultManagedObject = try managedContext.fetch(fetchRequest).last {
                guard let age = testResultManagedObject.value(forKey: "age")  as? Int,
                    let height = testResultManagedObject.value(forKey: "height") as? Int,
                    let gender = testResultManagedObject.value(forKey: "gender") as? Int,
                    let goal = testResultManagedObject.value(forKey: "goal") as? Int,
                    let currentWeight = testResultManagedObject.value(forKey: "currentWeight") as? Int,
                    let obesityType = testResultManagedObject.value(forKey: "obesityType") as? String else {
                        showRetryableErrorAlert(with: "Could not load test results".localized, retryAction: fetchTestResult)
                        return
                }
                results = TestResult()
                results?.age = age
                results?.goalWeight = goal
                results?.currentWeight = currentWeight
                results?.height = height
                results?.fatnessCategory = CategoryName(rawValue: obesityType)!
                results?.gender = gender == 0 ? .female : .male
                testCompleted(with: results!)
            }
        } catch {
            showRetryableErrorAlert(with: "Could not load test results".localized, retryAction: fetchTestResult)
        }
    }
    
    fileprivate func getFatnessCategoryNameForTeens(index: Double) -> CategoryName {
        
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
    }
    
    fileprivate func getFatnessCategoryForAdults(index: Double) -> CategoryName {
        
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
    }
    
    @IBAction func takeTestAgainButtonPressed(_ sender: Any) {
        self.repeatTest?()
        dismiss(animated: true, completion: nil)
    }
}

extension TestResultsView: TestResultOutput {
    
    func testCompleted(with result: TestResult) {
        self.results = result
        goalWeightTitleLabel.text = "\(result.goalWeight) " + "kg".localized
        currentWeightTitleLable.text = "\(result.currentWeight) " + "kg".localized
        timeTitleLabel.text = "\(result.height) " + "cm.".localized
        ageTitleLabel.text = "\(result.age)"
        genderTitleLabel.text = result.gender.description
        if result.gender == .male {
            genderIconImageView.image = UIImage(named: "male_icon")
        } else {
            genderIconImageView.image = UIImage(named: "female_icon ")
        }
    }
}
