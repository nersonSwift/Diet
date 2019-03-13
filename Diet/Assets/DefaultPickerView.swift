//
//  DefaultPickerView.swift
//  Diet
//
//  Created by Даниил on 31/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class DefaultPickerView: UIPickerView
{
    @IBInspectable var selectorColor: UIColor? = nil
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        guard let color = selectorColor else {
            return
        }
        
        if subview.bounds.height <= 1.0 {
            subview.backgroundColor = color
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard let color = selectorColor else {
            return
        }

        applyGradient()
        
        for subview in subviews {
            if subview.bounds.height <= 1.0 {
                subview.backgroundColor = color
            }
        }
    }
    
    private func applyGradient() {
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.3, 0.7, 1]
        self.layer.mask = gradient
    }
}
