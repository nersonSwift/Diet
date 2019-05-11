//
//  AnimButton.swift
//  AnimGround
//
//  Created by Александр Сенин on 07/05/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class AnimRingView: UIView {

    var firstRing:  UIView!
    var secondRing: UIView!
    var color: UIColor?
    var timer: Timer!
    var subView: UIView!
    
    init(subView: UIView) {
        super.init(frame: subView.frame)
        
        self.color = subView.backgroundColor
        self.subView = subView
        self.subView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: self.frame.width,
                                    height: self.frame.height)
        
        subView.backgroundColor = color
        
        firstRing = createRing()
        secondRing = createRing()
        
        self.addSubview(firstRing)
        self.addSubview(secondRing)
        self.addSubview(subView)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            self.animSubView(button: self.subView, delay: 0)
            self.animBorder(borderView: self.firstRing, delay: 0)
            self.animBorder(borderView: self.secondRing, delay: 0.2)
        })
        
    }
    
    func createRing() -> UIView{
        let ring = UIView(frame: self.subView.frame)
        
        ring.layer.cornerRadius = subView.layer.cornerRadius
        ring.layer.borderColor = color != nil ? color!.cgColor : #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 0)
        ring.layer.borderWidth = 2
        return ring
    }
    
    func animBorder(borderView: UIView, delay: TimeInterval){
        borderView.transform.a = 1
        borderView.transform.d = 1
        borderView.alpha = 1
        UIView.animate(withDuration: 1.2,
                       delay: delay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        borderView.transform.a = 1.2
                        borderView.transform.d = 1.7
                        borderView.alpha = 0
        }, completion: nil)
    }
    
    func animSubView(button: UIView, delay: TimeInterval){
        button.transform.a = 1
        button.transform.d = 1
        
        UIView.animate(withDuration: 0.2,
                       delay: delay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        button.transform.a = 1.05
                        button.transform.d = 1.05
        }){ (a) in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            button.transform.a = 1
                            button.transform.d = 1
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
