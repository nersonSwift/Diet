//
//  UIViewExtensions.swift
//  Diet
//
//  Created by Даниил on 07/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow(color: UIColor = .lightGray, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func makeCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0,y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0,y: 1.0)
        self.layer.insertSublayer(gradient, at: 1)
    }
}

extension UIButton {
    
    func animateWithPopupStyle() {
        UIView.animate(withDuration: 0.6,animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: { _ in
             UIView.animate(withDuration: 0.6) { [weak self] in
                self?.transform = CGAffineTransform.identity
            }
        })
    }
}

