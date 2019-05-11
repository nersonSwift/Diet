//
//  InfoView.swift
//  AnimGround
//
//  Created by Александр Сенин on 08/05/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class InfoView: UIView {

    var infoLable: UILabel!
    var infoSubLable: UILabel!
    
    var infoDescription: UILabel!
    var infoSubDescription: UILabel!
    
    var dopView: UIView!
    var border: UIView!
    
    var active: Bool = false{
        didSet{
            if active{
                border.layer.borderColor = #colorLiteral(red: 0.2941176471, green: 0.7960784314, blue: 0.3490196078, alpha: 1)
                border.layer.borderWidth = 1.5
            }else{
                border.layer.borderColor = #colorLiteral(red: 0.2941176471, green: 0.7960784314, blue: 0.3490196078, alpha: 0)
                border.layer.borderWidth = 1.5
            }
        }
    }
    
    init(frame: CGRect,
         lableText: String,
         subLableText: String,
         descriptionText: String,
         subDescriptionText: String) {
        
        super.init(frame: frame)
        let borderFrame = CGRect(x: 0,
                                 y: 0,
                                 width: self.frame.width,
                                 height: self.frame.height)
        border = UIView(frame: borderFrame)
        border.layer.cornerRadius = border.frame.height / 7
        self.addSubview(border)
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 7
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        
        let infoLableFrame = CGRect(x: self.frame.width * 0.07,
                                    y: self.frame.height * 0.12,
                                    width: 0,
                                    height: 0)
        infoLable = UILabel(frame: infoLableFrame)
        infoLable.text = lableText
        infoLable.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        infoLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Bold", size: 0),
                                size: self.frame.width / 11.5)
        infoLable.sizeToFit()
        self.addSubview(infoLable)
        
        let infoSubLableFrame = CGRect(x: self.frame.width * 0.07,
                                       y: infoLable.frame.maxY,
                                       width: 0,
                                       height: 0)
        infoSubLable = UILabel(frame: infoSubLableFrame)
        infoSubLable.text = subLableText
        infoSubLable.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        infoSubLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                   size: self.frame.width / 13)
        infoSubLable.sizeToFit()
        self.addSubview(infoSubLable)
        
        let infoDescriptionFrame = CGRect(x: self.frame.width * 0.07,
                                          y: self.frame.height / 2 + (self.frame.height / 2 - infoSubLable.frame.maxY),
                                          width: 0,
                                          height: 0)
        infoDescription = UILabel(frame: infoDescriptionFrame)
        infoDescription.text = descriptionText
        infoDescription.textColor = #colorLiteral(red: 0.5529411765, green: 0.5529411765, blue: 0.5529411765, alpha: 1)
        infoDescription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                   size: self.frame.width / 13)
        infoDescription.sizeToFit()
        self.addSubview(infoDescription)
        
        let infoSubDescriptionFrame = CGRect(x: self.frame.width * 0.07,
                                             y: infoDescription.frame.maxY,
                                             width: 0,
                                             height: 0)
        infoSubDescription = UILabel(frame: infoSubDescriptionFrame)
        infoSubDescription.text = subDescriptionText
        infoSubDescription.textColor = #colorLiteral(red: 0.5529411765, green: 0.5529411765, blue: 0.5529411765, alpha: 1)
        infoSubDescription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                         size: self.frame.width / 15)
        infoSubDescription.sizeToFit()
        self.addSubview(infoSubDescription)
    }
    
    func createDopView(textDopView: String){
        let dopViewFrame = CGRect(x: self.frame.width / 2,
                                  y: -self.frame.height * 0.095,
                                  width: self.frame.width * 0.4,
                                  height: self.frame.height * 0.19)
        dopView = UIView(frame: dopViewFrame)
        dopView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.7960784314, blue: 0.3490196078, alpha: 1)
        dopView.layer.cornerRadius = dopViewFrame.height / 7
        self.addSubview(dopView)
        
        let lableDopViewFrame = CGRect(x: 0,
                                       y: 0,
                                       width: dopViewFrame.width,
                                       height: dopViewFrame.height)
        let lableDopView = UILabel(frame: lableDopViewFrame)
        lableDopView.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                   size: self.frame.width / 19)
        lableDopView.text = textDopView
        lableDopView.textAlignment = .center
        lableDopView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dopView.addSubview(lableDopView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
