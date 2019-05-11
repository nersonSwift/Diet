//
//  InfoImageView.swift
//  AnimGround
//
//  Created by Александр Сенин on 09/05/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class InfoImageView: UIView {
    
    var infoImage: UIImageView!
    var infoButton: UIButtonP!
    
    var infoLable: UILabel!
    var infoSubLable: UILabel!
    
    var infoDescription: UILabel!
    var infoSubDescription: UILabel!
    
    init(frame: CGRect,
         lableText: String,
         subLableText: String,
         descriptionText: String,
         subDescriptionText: String,
         image: UIImage,
         textButton: String,
         clouserButton: @escaping ()->()) {
        
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 20
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        
        let infoImageFrame = CGRect(x: (self.frame.width / 2) - (self.frame.width * 0.22) / 2,
                                    y: self.frame.height * 0.06,
                                    width: self.frame.width * 0.22,
                                    height: self.frame.width * 0.22)
        infoImage = UIImageView(frame: infoImageFrame)
        infoImage.image = image
        self.addSubview(infoImage)
        
        let infoLableFrame = CGRect(x: 0,
                                    y: infoImageFrame.maxY + self.frame.height * 0.02,
                                    width: 0,
                                    height: 0)
        infoLable = UILabel(frame: infoLableFrame)
        infoLable.text = lableText
        infoLable.textAlignment = .center
        infoLable.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        infoLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                size: self.frame.width / 13)
        infoLable.sizeToFit()
        infoLable.center.x = self.frame.width / 2
        self.addSubview(infoLable)
        
        let infoSubLableFrame = CGRect(x: 0,
                                       y: infoLable.frame.maxY + self.frame.height * 0.02,
                                       width: self.frame.width * 0.9,
                                       height: 0)
        infoSubLable = UILabel(frame: infoSubLableFrame)
        infoSubLable.text = subLableText
        infoSubLable.textColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
        infoSubLable.textAlignment = .center
        infoSubLable.numberOfLines = 0
        
        infoSubLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                   size: self.frame.width / 20)
        infoSubLable.sizeToFit()
        infoSubLable.center.x = self.frame.width / 2
        self.addSubview(infoSubLable)
        
        let infoDescriptionFrame = CGRect(x: 0,
                                          y: self.frame.height / 2 + (self.frame.height / 2 - infoSubLable.frame.maxY),
                                          width: self.frame.width * 0.9,
                                          height: 0)
        infoDescription = UILabel(frame: infoDescriptionFrame)
        infoDescription.text = descriptionText
        infoDescription.textColor = #colorLiteral(red: 0.968627451, green: 0.262745098, blue: 0.2980392157, alpha: 1)
        infoDescription.textAlignment = .center
        infoDescription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                      size: self.frame.width / 11.8)
        infoDescription.sizeToFit()
        infoDescription.center.x = self.frame.width / 2
        self.addSubview(infoDescription)
        
        let infoSubDescriptionFrame = CGRect(x: 0,
                                             y: infoDescription.frame.maxY + self.frame.height * 0.03,
                                             width: 0,
                                             height: 0)
        infoSubDescription = UILabel(frame: infoSubDescriptionFrame)
        infoSubDescription.text = subDescriptionText
        infoSubDescription.textColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
        infoSubDescription.textAlignment = .center
        infoSubDescription.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                         size: self.frame.width / 25)
        infoSubDescription.sizeToFit()
        infoSubDescription.center.x = self.frame.width / 2
        self.addSubview(infoSubDescription)
        
        let infoButtonFrame = CGRect(x: 0,
                                     y: infoSubDescription.frame.maxY + self.frame.height * 0.07,
                                     width: self.frame.width * 0.9,
                                     height: self.frame.height * 0.17)
        infoButton = UIButtonP(frame: infoButtonFrame)
        infoButton.setTitle(textButton, for: .normal)
        infoButton.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.4352941176, blue: 0.4235294118, alpha: 1)
        infoButton.titleLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        infoButton.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                             size: self.frame.width / 15)
        infoButton.center.x = self.frame.width / 2
        infoButton.layer.cornerRadius = infoButton.frame.height / 4
        infoButton.addClosure(event: .touchUpInside, clouserButton)
        self.addSubview(infoButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
