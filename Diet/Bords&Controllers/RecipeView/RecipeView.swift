//
//  RecipeViewController.swift
//  Diet
//
//  Created by Даниил on 19/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol RecipeReciver: class {
    
    func recieve(dish: Dish)
}

class RecipeView: UIViewController, NavigationProtocol{
    var sub: Bool! = true
    var navigation: Navigation!
    
    var dish: Dish!
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let recipeView = storyboard.instantiateInitialViewController() as? RecipeView
        recipeView?.navigation = navigation
        return recipeView
    }
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    lazy var dishImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10, y: self.view.frame.height - 70, width: view.frame.width - 80, height: 50))
        btn.setTitle("Close".localized, for: .normal)
        btn.backgroundColor = UIColor(red: 251 / 255, green: 129 / 255, blue: 95 / 255, alpha: 1)
        view.addSubview(btn)
        return btn
    }()
    
    let networkService = NetworkService()
    var steps = [RecieptSteps]()
    var dishName = ""
    fileprivate let cachedImage = NSCache<AnyObject, AnyObject>()
    fileprivate let fetchingQueue = DispatchQueue.global(qos: .utility)
    
    var imageButton: UIImageView!
    var trig = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 70, right: 0)
        recipeTableView.register(UINib(nibName: "StepCell", bundle: nil), forCellReuseIdentifier: StepCell.identifier)
        recipeTableView.separatorStyle = .none
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.makeCornerRadius(10)
        
        
        let backButtonFrame = CGRect(x: closeButton.frame.maxX + 10,
                                     y: closeButton.frame.minY,
                                     width: 50,
                                     height: 50)
        let backButton = UIButtonP(frame: backButtonFrame)
        
        let imageButtonFrame = CGRect(x: 10,
                                      y: 10,
                                      width: 30,
                                      height: 30)
        imageButton = UIImageView(frame: imageButtonFrame)
        check()
        backButton.addSubview(imageButton)
        backButton.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        backButton.layer.cornerRadius = 10
        backButton.addClosure(event: .touchUpInside){
            if !self.trig{
                let a = DishModel()
                print(self.dish.imagePath)
                
                a.imagePath = self.dish.imagePath
                print(a.imagePath)
                
                a.name = self.dish.name
                a.calories = self.dish.nutritionValue.calories
                
                for i in self.dish.recipe{
                    let b = RecipeModel()
                    b.name = i.name
                    b.descriptioN = i.description
                    b.imagePaths = i.imagePaths[0]
                    
                    try! self.navigation.realmData.realm.write{
                        self.navigation.realmData.realm.add(b)
                    }
                    a.recipe.append(b)
                }
                
                try! self.navigation.realmData.realm.write{
                    self.navigation.realmData.realm.add(a)
                }
            }else{
                for i in self.navigation.realmData.dishModels{
                    if i.name == self.dish.name{
                        i.del()
                    }
                }
            }
            self.check()
            
        }
        view.addSubview(backButton)
    }
    
    func check(){
        for i in navigation.realmData.dishModels{
            if i.name == dish.name{
                imageButton.image = UIImage(named: "star1")
                trig = true
                return
            }
        }
        imageButton.image = UIImage(named: "star")
        trig = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return recipeTableView.contentOffset.y >= 100
    }
    
    @objc func closeButtonPressed() {
        navigation.back(animated: true,
                        completion: nil){ next in
                            if let favoritesView = next as? FavoritesView{
                                favoritesView.createDie()
                            }
        }
    }
}

extension RecipeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("DishNameHeaderView", owner: self, options: nil)?[0] as? DishNameHeaderView
        view?.titleLabel.text = dishName
        return view
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        setNeedsStatusBarAppearanceUpdate()
        
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y,0), 350)
        dishImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
}

extension RecipeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCell.identifier, for: indexPath) as? StepCell else {
            return UITableViewCell()
        }
        let step = steps[indexPath.row]
        
        cell.stepNameLabel.text = step.name
        cell.stepDescriptionLabel.text = step.description
        
        guard let imagePath = step.imagePaths.first else { return cell }
        
        fetchingQueue.async {
            request(imagePath).responseImage { (response) in
                guard let image = response.result.value else {
                    print("Image for dish  - \(step.name) is NIL")
                    return
                }
                DispatchQueue.main.async {
                    cell.stepImageView.image = image
                    self.cachedImage.setObject(image, forKey: imagePath as AnyObject)
                }
            }
        }
        
        return cell
    }
}

extension RecipeView: RecipeReciver {
    
    func recieve(dish: Dish)
    {
        self.dish = dish
        steps = dish.recipe
        dishName = dish.name
        request(dish.imagePath).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async { [weak self] in
                    self?.dishImageView.image = image
                }
            }
        }
    }
}

extension RecipeView: LoadingTimeoutHandler {
    
    func didTimeoutOccured() {
//
//        let timeoutMessageParagraphStyle = NSMutableParagraphStyle()
//        timeoutMessageParagraphStyle.alignment = .center
//        timeoutMessageParagraphStyle.paragraphSpacingBefore = 100
//
//        let timeoutHappendMessage = NSAttributedString(string: "Could not load data.".localized, attributes: [NSAttributedString.Key.paragraphStyle : timeoutMessageParagraphStyle])
//
//        recipeLabel.attributedText = timeoutHappendMessage
    }
}
