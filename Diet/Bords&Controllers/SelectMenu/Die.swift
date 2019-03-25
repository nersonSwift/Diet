//
//  Die.swift
//  Diet
//
//  Created by Александр Сенин on 22/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class Die: UIView{
    
    var image: UIImage!{
        didSet {
            imageV.image = image
        }
    }
    var title: String!{
        didSet {
            titleV.text = title
        }
    }
    var descript: String!{
        didSet {
            let attributedString = NSMutableAttributedString(string: descript)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4.5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            descriptV.attributedText = attributedString
        }
    }
    var recomend: Bool = false{
        didSet {
            if recomend{
                recomendV.isHidden = false
                self.layer.shadowRadius = 6
                self.layer.shadowOpacity = 1
                self.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
                self.layer.borderColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
                self.layer.borderWidth = 3
            }else{
                recomendV.isHidden = true
                self.layer.shadowRadius = 4
                self.layer.shadowOpacity = 0.2
                self.layer.borderWidth = 0
                self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    var button: UIButtonP!
    private var foundation: UIView!
    private var imageV: UIImageView!
    private var titleV: UILabel!
    private var descriptV: UILabel!
    private var recomendV: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let foundationFrame = CGRect(x: 0,
                            y: 0,
                            width: frame.width,
                            height: frame.height)
        foundation = UIView(frame: foundationFrame)
        foundation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.addSubview(foundation)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.cornerRadius = 40
        
        let maskPath = UIBezierPath(roundedRect: foundation.bounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer = CAShapeLayer(layer: maskPath)
        maskLayer.path = maskPath.cgPath
        foundation.layer.mask = maskLayer
        
        let imageVFrame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: frame.height * 0.55)
        imageV = UIImageView(frame: imageVFrame)
        foundation.addSubview(imageV)
        
        let buttonFrame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: frame.height)
        button = UIButtonP(frame: buttonFrame)
        self.addSubview(button)
        
        let recomendVFrame = CGRect(x: 0,
                                    y: imageVFrame.maxY - (foundation.frame.height * 0.1),
                                    width: foundation.frame.width * 0.4,
                                    height: foundation.frame.height * 0.1)
        recomendV = UIView(frame: recomendVFrame)
        recomendV.isHidden = true
        recomendV.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        foundation.addSubview(recomendV)
        
        let recomendVMaskPath = UIBezierPath(roundedRect: recomendV.bounds,
                                             byRoundingCorners: .topRight,
                                             cornerRadii: CGSize(width: 5, height: 5))
        let recomendVMaskLayer = CAShapeLayer(layer: recomendVMaskPath)
        recomendVMaskLayer.path = recomendVMaskPath.cgPath
        recomendV.layer.mask = recomendVMaskLayer
        
        let recomendVTextFrame = CGRect(x: 0,
                                        y: 0,
                                        width: recomendVFrame.width,
                                        height: recomendVFrame.height)
        let recomendVText = UILabel(frame: recomendVTextFrame)
        recomendVText.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Light", size: 0),
                             size: ((frame.height + frame.width) / 2) / 20)
        recomendVText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        recomendVText.textAlignment = .center
        recomendVText.text = "Рекомендовано"
        recomendV.addSubview(recomendVText)
        
        
        let titleVFrame = CGRect(x: frame.width * 0.05,
                                 y: imageVFrame.maxY,
                                 width: frame.width * 0.9,
                                 height: frame.height * 0.17)
        titleV = UILabel(frame: titleVFrame)
        titleV.text = "..."
        titleV.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Neue Regular", size: 0),
                             size: ((frame.height + frame.width) / 2) / 12)
        titleV.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        foundation.addSubview(titleV)
        
        let descriptVFrame = CGRect(x: frame.width * 0.05,
                                    y: titleVFrame.maxY,
                                    width: frame.width * 0.9,
                                    height: frame.height * 0.17)
        descriptV = UILabel(frame: descriptVFrame)
        descriptV.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Light", size: 0),
                             size: ((frame.height + frame.width) / 2) / 17)
        descriptV.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        descriptV.numberOfLines = 0
        
        let attributedString = NSMutableAttributedString(string: "...")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        descriptV.attributedText = attributedString
        foundation.addSubview(descriptV)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
