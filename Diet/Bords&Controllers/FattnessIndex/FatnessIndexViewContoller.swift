//
//  FatnessIndexViewContoller.swift
//  Diet
//
//  Created by Даниил on 03/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

struct FatnessCategory {
    var icon: String
    var title: String
    var backgroundColor: UIColor
    var categoryName: CategoryName
}

class FatnessIndexViewContoller: UIViewController {

    @IBOutlet weak var fatnessIndexLabel: AnimatedLabel!
    @IBOutlet weak var fatnessCategoriesCollectionView: UICollectionView!
    fileprivate let underWeightCategoryColor = UIColor(red: 237 / 255, green: 249 / 255, blue: 255 / 255, alpha: 1.0)
    fileprivate let normalWeightCategoryColor = UIColor(red: 220 / 255, green: 255 / 255, blue: 240 / 255, alpha: 1.0)
    fileprivate let excessWeightCategoryColor = UIColor(red: 255 / 255, green: 235 / 255, blue: 231 / 255, alpha: 1.0)
    fileprivate let obesityCategoryColor = UIColor(red: 255 / 255, green: 215 / 255, blue: 207 / 255, alpha: 1.0)
    fileprivate let severObesityCategoryColor = UIColor(red: 255 / 255, green: 202 / 255, blue: 202 / 255, alpha: 1.0)
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var getDietsButton: UIButton!
    
    var fatnessIndex: Double = 0.0
    var testResults: TestResult?
    var fatnessCategories = [FatnessCategory]()
    let topCellOffset: CGFloat = 10.0
    let cellHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fatnessCategoriesCollectionView.dataSource = self
        getDietsButton.layer.cornerRadius = 15
        getDietsButton.layer.masksToBounds = true
        
        fatnessCategories.append(FatnessCategory(icon: "underweight", title: "Underweight".localized, backgroundColor: underWeightCategoryColor, categoryName: .underweight))
        fatnessCategories.append(FatnessCategory(icon: "normal", title: "Normal weight".localized, backgroundColor: normalWeightCategoryColor, categoryName: .normal))
        fatnessCategories.append(FatnessCategory(icon: "excess", title: "Excess obesity".localized, backgroundColor: excessWeightCategoryColor, categoryName: .excessObesity))
        fatnessCategories.append(FatnessCategory(icon: "obesity", title: "Obesity".localized, backgroundColor: obesityCategoryColor, categoryName: .obesity))
        fatnessCategories.append(FatnessCategory(icon: "severe", title: "Severe obesity".localized, backgroundColor: severObesityCategoryColor, categoryName: .severeObesity))
        
        fatnessCategoriesCollectionView.register(UINib(nibName: "FatnessCategoryCell", bundle: nil), forCellWithReuseIdentifier: FatnessCategoryCell.identifier)
        
    }
    
    override func viewDidLayoutSubviews() {
        moveArrowsToStartPosition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDiets" {
            
            if let destinationVc = segue.destination as? DietViewController {
                destinationVc.accessStatus = .available
                if let category = self.testResults?.fatnessCategory {
                    destinationVc.bodyCategory = category
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let result = testResults else { return }
        
        fatnessIndexLabel.countFromZero(to: Float(fatnessIndex))
        fatnessIndexLabel.completion = {
            
            if result.fatnessCategory == .underweight {
                self.animateArrows()
            } else {
                guard let index = self.fatnessCategories.firstIndex(where: { (category) -> Bool in
                    category.categoryName == result.fatnessCategory
                }) else { return }
                self.moveArrowsToCell(with: index)
            }
        }
    }
    
    fileprivate func animateArrows() {
        UIView.animate(withDuration: 0.4, animations: {
            self.leftArrow.frame.size.width += 5
            self.leftArrow.frame.size.height += 10
            self.rightArrow.frame.size.width += 5
            self.rightArrow.frame.size.height += 10
        }) { (f) in
            UIView.animate(withDuration: 0.5) {
                self.leftArrow.frame.size.width -= 5
                self.leftArrow.frame.size.height -= 10
                self.rightArrow.frame.size.width -= 5
                self.rightArrow.frame.size.height -= 10
            }
        }
    }
    
    fileprivate func moveArrowsToStartPosition() {
        arrowView.frame = CGRect(x: 0, y: fatnessCategoriesCollectionView.frame.minY + topCellOffset, width: self.view.frame.width, height: 50)
    }
    
    fileprivate func moveArrowsToCell(with index: Int) {
        
        UIView.animate(withDuration: 1, animations: {
            self.arrowView.frame.origin.y += (self.cellHeight + self.topCellOffset) * CGFloat(index);
        }) { (f) in
            self.animateArrows()
        }
    }
    
    @IBAction func getDietsButtonPressed(_ sender: Any) {
        
        if SubscriptionService.shared.currentSubscription == nil {
            performSegue(withIdentifier: "showSubOffer", sender: self)
        } else {
            performSegue(withIdentifier: "showDiets", sender: self)
        }
    }
}

extension FatnessIndexViewContoller: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fatnessCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FatnessCategoryCell.identifier, for: indexPath) as? FatnessCategoryCell else {
            return UICollectionViewCell()
        }
        
        cell.iconImageView.image = UIImage(named: fatnessCategories[indexPath.row].icon)
        cell.title.text = fatnessCategories[indexPath.row].title
        cell.backgroundColor = fatnessCategories[indexPath.row].backgroundColor
        
        return cell
    }
}
