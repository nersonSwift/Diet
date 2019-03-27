//
//  ProfilView.swift
//  Diet
//
//  Created by Александр Сенин on 26/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class ProfilView: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    var sub: Bool! = true
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let profilView = storyboard.instantiateInitialViewController() as? ProfilView
        profilView?.navigation = navigation
        return profilView
    }
    
    var header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
    }
    
    func createView(){
        let headerFrame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width,
                                 height: view.frame.height * 0.16)
        header = UIView(frame: headerFrame)
        header.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        header.layer.shadowRadius = 3
        header.layer.shadowOpacity = 0.2
        header.layer.borderWidth = 0
        header.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        view.addSubview(header)
        
        let headerLable = UILabel(frame: headerFrame)
        headerLable.text = "Profile".localized
        headerLable.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        headerLable.textAlignment = .center
        headerLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                  size: ((view.frame.height + view.frame.width) / 2) / 18)
        header.addSubview(headerLable)
        
        let backButtonFrame = CGRect(x: view.frame.width * 0.1,
                                     y: 0,
                                     width: view.frame.width * 0.05,
                                     height: (view.frame.width * 0.05) * 1.7)
        let backButton = UIButtonP(frame: backButtonFrame)
        backButton.center.y = header.center.y
        backButton.layer.contents = UIImage(named: "arrow")?.cgImage
        backButton.alpha = 0.7
        backButton.layer.shadowRadius = 3
        backButton.layer.shadowOpacity = 0.4
        backButton.layer.borderWidth = 0
        backButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backButton.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        backButton.addClosure(event: .touchUpInside){
            self.navigation.back(animated: true, completion: nil, special: nil)
        }
        header.addSubview(backButton)
        
        let genderViewFrame = CGRect(x: (view.frame.width / 2) - (view.frame.width * 0.28) / 2 ,
                                     y: header.frame.maxY + (view.frame.width * 0.28) / 4,
                                     width: view.frame.width * 0.28,
                                     height: view.frame.width * 0.28)
        var gender = Gender.male
        if navigation.realmData.userModel!.gender{
            gender = .female
        }
        
        let genderView = UIImageView(frame: genderViewFrame)
        if gender == .male {
            genderView.image = UIImage(named: "male_icon")
        } else {
            genderView.image = UIImage(named: "female_icon")
        }
        view.addSubview(genderView)
        
        let genderLableFrame = CGRect(x: 0,
                                      y: genderViewFrame.maxY,
                                      width: 0,
                                      height: view.frame.height * 0.7)
        let genderLable = UILabel(frame: genderLableFrame)
        genderLable.text = gender.description
        genderLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                                  size: ((view.frame.height + view.frame.width) / 2) / 25)
        genderLable.sizeToFit()
        genderLable.textAlignment = .center
        genderLable.center.x = view.center.x
        view.addSubview(genderLable)
        
        let genderBotLableFrame = CGRect(x: 0,
                                         y: genderLable.frame.maxY,
                                         width: 0,
                                         height: view.frame.height * 0.7)
        let genderBotLable = UILabel(frame: genderBotLableFrame)
        genderBotLable.text = "your gender".localized
        genderBotLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Italic", size: 0),
                                     size: ((view.frame.height + view.frame.width) / 2) / 30)
        genderBotLable.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        genderBotLable.sizeToFit()
        genderBotLable.textAlignment = .center
        genderBotLable.center.x = view.center.x
        view.addSubview(genderBotLable)
        
        let textAgeFrame = CGRect(x: view.frame.width * 0.06,
                                  y: view.center.y,
                                  width: 0,
                                  height: 0)
        let textAge = UILabel(frame: textAgeFrame)
        textAge.text = "Your age".localized
        textAge.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                              size: ((view.frame.height + view.frame.width) / 2) / 19)
        textAge.sizeToFit()
        view.addSubview(textAge)
        
        let textWeightFrame = CGRect(x: view.frame.width * 0.06,
                                     y: textAge.frame.maxY + view.frame.height * 0.05,
                                     width: 0,
                                     height: 0)
        let textWeight = UILabel(frame: textWeightFrame)
        textWeight.text = "Your weight".localized
        textWeight.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                                 size: ((view.frame.height + view.frame.width) / 2) / 19)
        textWeight.sizeToFit()
        view.addSubview(textWeight)
        
        let textLoseFrame = CGRect(x: view.frame.width * 0.06,
                                   y: textWeight.frame.maxY + view.frame.height * 0.05,
                                   width: 0,
                                   height: 0)
        let textLose = UILabel(frame: textLoseFrame)
        textLose.text = "Your height".localized
        textLose.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                               size: ((view.frame.height + view.frame.width) / 2) / 19)
        textLose.sizeToFit()
        view.addSubview(textLose)
        
        let fieldAgeFrame = CGRect(x: view.frame.width * 0.94,
                                   y: view.center.y,
                                   width: 0,
                                   height: 0)
        let fieldAge = UILabel(frame: fieldAgeFrame)
        fieldAge.text = "\(navigation.realmData.userModel!.age)"
        fieldAge.textAlignment = .center
        fieldAge.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                               size: ((view.frame.height + view.frame.width) / 2) / 19)
        fieldAge.sizeToFit()
        fieldAge.transform.tx -= fieldAge.frame.width
        //fieldAge.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //fieldAge.layer.borderWidth = 3
        view.addSubview(fieldAge)
        
        let fieldWeightFrame = CGRect(x: view.frame.width * 0.94,
                                      y: textAge.frame.maxY + view.frame.height * 0.05,
                                      width: 0,
                                      height: 0)
        let fieldWeight = UILabel(frame: fieldWeightFrame)
        fieldWeight.text = "\(navigation.realmData.userModel!.currentWeight)"
        fieldWeight.textAlignment = .center
        fieldWeight.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                                  size: ((view.frame.height + view.frame.width) / 2) / 19)
        fieldWeight.sizeToFit()
        fieldWeight.transform.tx -= fieldWeight.frame.width
        view.addSubview(fieldWeight)
        
        let fieldLoseFrame = CGRect(x: view.frame.width * 0.94,
                                    y: textWeight.frame.maxY + view.frame.height * 0.05,
                                    width: 0,
                                    height: 0)
        let fieldLose = UILabel(frame: fieldLoseFrame)
        fieldLose.text = "\(navigation.realmData.userModel!.height)"
        fieldLose.textAlignment = .center
        fieldLose.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                                size: ((view.frame.height + view.frame.width) / 2) / 19)
        fieldLose.sizeToFit()
        fieldLose.transform.tx -= fieldLose.frame.width
        view.addSubview(fieldLose)
        
        let repitTestFrame = CGRect(x: 0,
                                    y: view.frame.height * 0.85,
                                    width: view.frame.width * 0.8,
                                    height: view.frame.height * 0.1)
        let repitTest = UIButtonP(frame: repitTestFrame)
        repitTest.center.x = view.center.x
        repitTest.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        repitTest.setTitle("Take the test again".localized, for: .normal)
        repitTest.layer.cornerRadius = repitTestFrame.height / 5
        repitTest.layer.shadowRadius = 4
        repitTest.layer.shadowOpacity = 0.2
        repitTest.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        repitTest.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                            size: ((self.view.frame.height + self.view.frame.width) / 2) / 25)
        repitTest.addClosure(event: .touchUpInside){
            self.navigation.transitionToView(viewControllerType: TestPageView(coder: NSCoder())!, animated: true, special: nil)
        }
        
        view.addSubview(repitTest)
    }

}
