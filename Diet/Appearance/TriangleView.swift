//
//  TriangleView.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class Triangle: UIView {
    
    override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        
        let width = self.layer.bounds.size.width
        let height = self.layer.bounds.size.height
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let triangleShadow = CGMutablePath()
        
        triangleShadow.move(to: CGPoint(x: 0, y: 0))
        triangleShadow.addLine(to: CGPoint(x: width, y: 0))
        triangleShadow.addLine(to: CGPoint(x: width / 2, y: height))
        triangleShadow.addLine(to: CGPoint(x: 0, y: 0))
    
        mask.shadowPath = triangleShadow
        mask.path = path
        self.layer.mask = mask
    }
}
