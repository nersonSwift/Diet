//
//  FavoritesView.swift
//  Diet
//
//  Created by Александр Сенин on 25/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FavoritesView: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    var search: UITextField!
    var searchFoundation: UIView!
    var sub: Bool! = true
    var dies: [Die] = []
    var trig = false
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let favoritesView = storyboard.instantiateInitialViewController() as? FavoritesView
        favoritesView?.navigation = navigation
        return favoritesView
    }
    

    var scrollView: UIScrollView!
    var header: UIView!
    fileprivate let fetchingQueue = DispatchQueue.global(qos: .utility)
    
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
                                 height: view.frame.height * 0.16)
        header = UIView(frame: headerFrame)
        header.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.8196078431, blue: 0.1921568627, alpha: 1)
        header.layer.shadowRadius = 3
        header.layer.shadowOpacity = 0.2
        header.layer.borderWidth = 0
        header.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        scrollView.addSubview(header)
        
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
        
        let headerLable = UILabel(frame: headerFrame)
        headerLable.text = "Selected recipes:".localized
        headerLable.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        headerLable.textAlignment = .center
        headerLable.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0),
                                  size: ((view.frame.height + view.frame.width) / 2) / 23)
        header.addSubview(headerLable)
        
        let searchFoundationFrame = CGRect(x: view.frame.width * 0.05,
                                 y: header.frame.maxY + view.frame.width * 0.02,
                                 width: view.frame.width * 0.9,
                                 height: headerFrame.height / 2)
        searchFoundation = UIView(frame: searchFoundationFrame)
        searchFoundation.layer.cornerRadius = 15
        searchFoundation.layer.borderColor = #colorLiteral(red: 0.3333011568, green: 0.3333538771, blue: 0.3332896829, alpha: 1)
        searchFoundation.layer.borderWidth = 3
        scrollView.addSubview(searchFoundation)
        
        let searchIconFrame = CGRect(x: (headerFrame.height / 2) * 0.2,
                                     y: (headerFrame.height / 2) * 0.2,
                                     width:  (headerFrame.height / 2) * 0.6,
                                     height: (headerFrame.height / 2) * 0.6)
        let searchIcon = UIImageView(frame: searchIconFrame)
        searchIcon.image = Image(named: "glassearch")
        searchFoundation.addSubview(searchIcon)
        
        let searchFrame = CGRect(x: searchIconFrame.maxX,
                                 y: searchIconFrame.minY,
                                 width: searchFoundationFrame.width - searchIconFrame.width * 2,
                                 height: (headerFrame.height / 2) * 0.6)
        search = UITextField(frame: searchFrame)
        search.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0),
                             size: ((view.frame.height + view.frame.width) / 2) / 25)
        search.delegate = self
        searchFoundation.addSubview(search)
        createDie()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(offPad))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    func createDie(){
        for i in dies{
            i.removeFromSuperview()
        }
        dies = []
        
        if let dishModels = navigation.realmData.dishModels{
            for i in 0..<dishModels.count{
                let h: CGFloat = view.frame.width * 0.72
                let dieFrame = CGRect(x: view.frame.width * 0.05,
                                      y: (searchFoundation.frame.maxY + view.frame.width * 0.12) + ((h + view.frame.width * 0.05) * CGFloat(i)),
                                      width: view.frame.width * 0.9,
                                      height: h)
                let die = Die(frame: dieFrame)
                dies.append(die)
                let imagePath = dishModels[i].imagePath
                
                fetchingQueue.async {
                    request(imagePath).responseImage { (response) in
                        
                        guard let image = response.result.value else {
                            DispatchQueue.main.async {
                                
                                die.image = UIImage(named: "no_food")
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            
                            die.image = image
                        }
                    }
                }
                
                die.title = dishModels[i].name
                die.titleV.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Neue Regular", size: 0),
                                         size: ((view.frame.height + view.frame.width) / 2) / 25)
                die.descript = "\(dishModels[i].calories)" + " kCal.".localized
                
                die.button.addClosure(event: .touchUpInside){
                    if self.trig{
                        return
                    }
                    var recipes: [RecieptSteps] = []
                    for j in dishModels[i].recipe{
                        let recipe = RecieptSteps(name: j.name,
                                                  description: j.descriptioN,
                                                  imagePaths: [j.imagePaths])
                        recipes.append(recipe)
                    }
                    let dish = Dish(name: dishModels[i].name,
                                    imagePath: dishModels[i].imagePath,
                                    nutritionValue: NutritionalValue(calories: dishModels[i].calories,
                                                                     protein: dishModels[i].protein,
                                                                     carbs: dishModels[i].carbs,
                                                                     fats: dishModels[i].fats),
                                    recipe: recipes)
                    self.navigation.transitionToView(viewControllerType: RecipeView(), animated: true){ nextViewController in
                        let recipeView = nextViewController as! RecipeView
                        recipeView.recieve(dish: dish)
                    }
                }
                
                scrollView.addSubview(die)
                
                if i == dishModels.count - 1{
                    scrollView.contentSize = CGSize(width: view.frame.width,
                                                    height: dieFrame.maxY + 20)
                }
            }
        }
    }
    
    func createDie(diesSirch: [Die]){
        for i in dies{
            i.removeFromSuperview()
        }
        let h: CGFloat = view.frame.width * 0.72
        for i in 0..<diesSirch.count{
            let dieFrame = CGRect(x: view.frame.width * 0.05,
                                  y: (searchFoundation.frame.maxY + view.frame.width * 0.12) + ((h + view.frame.width * 0.05) * CGFloat(i)),
                                  width: view.frame.width * 0.9,
                                  height: h)
            diesSirch[i].frame = dieFrame
            scrollView.addSubview(diesSirch[i])
            if i == diesSirch.count - 1{
                scrollView.contentSize = CGSize(width: view.frame.width,
                                                height: dieFrame.maxY + 20)
            }
        }
    }
    
    @objc func offPad(){
        if self.search.isEditing{
            view.endEditing(true)
            trig = true
        }else{
            trig = false
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

extension FavoritesView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var diesSirch: [Die] = []
        var newText = textField.text! + string
        if string == ""{
            newText.removeLast()
        }
        if newText == ""{
            createDie()
            return true
        }
        
        for i in dies{
            if i.title.contains(newText){
                diesSirch.append(i)
            }
        }
        createDie(diesSirch: diesSirch)
        print("--")
        
        return true
    }
}
