//
//  SelectMenu.swift
//  Diet
//
//  Created by Александр Сенин on 22/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

struct DieInfo{
    var dieLabel: String
    var dieDescript: String
    var dieImageName: String
}

class SelectMenu: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    
    var sub: Bool! = true
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let selectMenu = storyboard.instantiateInitialViewController() as? SelectMenu
        selectMenu?.navigation = navigation
        return selectMenu
    }
    
    
    var scrollView: UIScrollView!
    var header: UIView!
    var dies: [Die] = []
    var dieInfo = [DieInfo(dieLabel:     "Superfit 1000",
                           dieDescript:  "Ration at 1000 kcal/daily is way for quick weight loss.".localized,
                           dieImageName: "superfit"),
                   DieInfo(dieLabel:     "Fit 1200",
                           dieDescript:  "Ration at 1200 kcal/daily for healthy weight loss.".localized,
                           dieImageName: "fit"),
                   DieInfo(dieLabel:     "Daily 1400",
                           dieDescript:  "Ration at 1400 kcal/daily to maintain current form or calm weight loss.".localized,
                           dieImageName: "daily"),
                   DieInfo(dieLabel:     "Balance 2000",
                           dieDescript:  "Ration at 2000 kcal/daily for those who lead an active lifestyle.".localized,
                           dieImageName: "balans"),
                   DieInfo(dieLabel:     "Power 2500",
                           dieDescript:  "Ration at 2500 kcal/daily for those who are actively practise dtsports.".localized,
                           dieImageName: "Power")]

    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollViewFrame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
        
        scrollView = UIScrollView(frame: scrollViewFrame)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
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
        scrollView.addSubview(header)
        
        let headerLable = UILabel(frame: headerFrame)
        headerLable.text = "Choose a diet for yourself:".localized
        headerLable.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        headerLable.textAlignment = .center
        headerLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                           size: ((view.frame.height + view.frame.width) / 2) / 23)
        header.addSubview(headerLable)
        
        var recomendDiet = 0
        let bodyCategory = CategoryName.init(rawValue: navigation.realmData.userModel!.obesityType)!
        switch bodyCategory {
        case .underweight:
            recomendDiet = 4
        case .normal:
            recomendDiet = 3
        case .excessObesity:
            recomendDiet = 2
        case .obesity:
            recomendDiet = 1
        case .severeObesity:
            recomendDiet = 0
        case .undefined:
            recomendDiet = 3
        }
        var body: [CategoryName] = [.severeObesity, .obesity, .excessObesity, .normal, .underweight]
        
        for i in 0...4{
            let h: CGFloat = view.frame.width * 0.72
            let dieFrame = CGRect(x: view.frame.width * 0.05,
                                  y: (header.frame.maxY + view.frame.width * 0.02) + ((h + view.frame.width * 0.05) * CGFloat(i)),
                                  width: view.frame.width * 0.9,
                                  height: h)
            let die = Die(frame: dieFrame)
            die.image = UIImage(named: dieInfo[i].dieImageName)
            die.title = dieInfo[i].dieLabel
            die.descript = dieInfo[i].dieDescript
            die.button.addClosure(event: .touchUpInside){
                
                self.navigation.transitionToView(viewControllerType: DietsWeek(), animated: true){ next in
                    let dietsWeek = next as! DietsWeek
                    self.navigation.realmData.userModel!.obesityTypeSelect = "\(body[i])"
                    print(self.navigation.realmData.userModel!.obesityTypeSelect)
                    dietsWeek.createView()
                }
            }
            dies.append(die)
            scrollView.addSubview(die)
            if i == recomendDiet{
                die.recomend = true
            }
            if i == 4{
                scrollView.contentSize = CGSize(width: view.frame.width,
                                                height: dieFrame.maxY + 20)
            }
        }
        
        
    }

}

extension SelectMenu: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -10{
            return
        }
        let imageViewFrame = CGRect(x: 0,
                                    y: scrollView.contentOffset.y,
                                    width: view.frame.width,
                                    height: view.frame.height * 0.13)
        header.frame = imageViewFrame
    }
}

