//
//  GenderSelectorViewController.swift
//  Diet
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

enum Gender: String {
    case male
    case female
    case undefined
    
    var description: String {
        get {
            switch self {
            case .male:
                return "Male".localized
            case .female:
                return "Female".localized
            case .undefined:
                return "Undefined".localized
            }
        }
    }
}

class GenderSelectorViewController: UIViewController {
    
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleIconImageView: UIImageView!
    @IBOutlet weak var maleIconImageView: UIImageView!
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var topLeafImageView: UIImageView!
    @IBOutlet weak var midHighLeafImageView: UIImageView!
    @IBOutlet weak var midLowImageView: UIImageView!
    @IBOutlet weak var bottomLeafImageView: UIImageView!
    
    private let topGradientColor = UIColor(red: 59 / 255, green: 184 / 255, blue: 72 / 255, alpha: 1)
    private let bottomGradientColor = UIColor(red: 0, green: 158 / 255, blue: 91 / 255, alpha: 1)
    
    var nextButtonPressed: (() -> Void)?
    var genderSelected: ((Gender) -> Void)?
    var topLeafPosition: CGFloat = 0
    var midHighLeafPosition: CGFloat = 0
    var midLowLeafPosition: CGFloat = 0
    var bottomLeafPosition: CGFloat = 0
    var leavesImages = [UIImageView]()
    var countOfLeavesImages = 5
    var genderStackViewStartPosition: CGFloat = 0
    var foodImageStartPosition: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stepsLabel.alpha = 0
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            guard let self = self else { return }
            self.topLeafImageView.frame.origin.x = self.topLeafPosition
            self.midHighLeafImageView.frame.origin.x = self.midHighLeafPosition
            self.midLowImageView.frame.origin.x = self.midLowLeafPosition
            self.bottomLeafImageView.frame.origin.x = self.bottomLeafPosition
            self.genderStackView.frame.origin.x = self.genderStackViewStartPosition
            self.fruitImageView.frame.origin.x = self.foodImageStartPosition
        }) { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.stepsLabel.alpha = 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.topLeafImageView.frame.origin.x = -(self.topLeafImageView.frame.width)
            self.midHighLeafImageView.frame.origin.x = -(self.midHighLeafImageView.frame.width)
            self.midLowImageView.frame.origin.x = -(self.midLowImageView.frame.width)
            self.bottomLeafImageView.frame.origin.x = -(self.bottomLeafImageView.frame.width)
            self.genderStackView.frame.origin.x = -(self.genderStackView.frame.width)
            self.fruitImageView.frame.origin.x = -(self.fruitImageView.frame.width)
        }
        
        for leaf in leavesImages {
            leaf.frame.origin.x = -leaf.frame.width
        }
    }
    
    override func viewDidLayoutSubviews() {
        genderStackViewStartPosition = genderStackView.frame.origin.x
        topLeafPosition = topLeafImageView.frame.origin.x
        midHighLeafPosition = midHighLeafImageView.frame.origin.x
        midLowLeafPosition = midLowImageView.frame.origin.x
        bottomLeafPosition = bottomLeafImageView.frame.origin.x
        foodImageStartPosition = fruitImageView.frame.origin.x
    }
    
    private func setupView() {
        femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
        maleButton.layer.cornerRadius = maleButton.frame.height / 2
        view.applyGradient(colours: [topGradientColor, bottomGradientColor])
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderSelected?(.male)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderSelected?(.female)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
}
