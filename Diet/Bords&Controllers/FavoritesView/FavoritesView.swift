//
//  FavoritesView.swift
//  Diet
//
//  Created by Александр Сенин on 25/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class FavoritesView: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    
    var sub: Bool! = true
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let favoritesView = storyboard.instantiateInitialViewController() as? FavoritesView
        favoritesView?.navigation = navigation
        return favoritesView
    }
    

    var scrollView: UIScrollView!
    var header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                                 height: view.frame.height * 0.14)
        header = UIView(frame: headerFrame)
        header.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        header.layer.shadowRadius = 3
        header.layer.shadowOpacity = 0.2
        header.layer.borderWidth = 0
        header.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        scrollView.addSubview(header)
        
        let headerLable = UILabel(frame: headerFrame)
        headerLable.text = "Выберете рацион для себя:"
        headerLable.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        headerLable.textAlignment = .center
        headerLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                  size: ((view.frame.height + view.frame.width) / 2) / 23)
        header.addSubview(headerLable)
        
        for i in 0...navigation.realmData.dishModels!.count{
            let h: CGFloat = view.frame.width * 0.72
            let dieFrame = CGRect(x: view.frame.width * 0.05,
                                  y: (header.frame.maxY + view.frame.width * 0.02) + ((h + view.frame.width * 0.05) * CGFloat(i)),
                                  width: view.frame.width * 0.9,
                                  height: h)
            let die = Die(frame: dieFrame)
            scrollView.addSubview(die)
        
            if i == 4{
                scrollView.contentSize = CGSize(width: view.frame.width,
                                                height: dieFrame.maxY + 20)
            }
        }
    }
    

}

extension FavoritesView: UIScrollViewDelegate {
    
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
