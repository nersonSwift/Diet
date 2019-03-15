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
    var navigation: Navigation!
    
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
        let btn = UIButton(frame: CGRect(x: 10, y: self.view.frame.height - 70, width: view.frame.width - 20, height: 50))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 70, right: 0)
        recipeTableView.register(UINib(nibName: "StepCell", bundle: nil), forCellReuseIdentifier: StepCell.identifier)
        recipeTableView.separatorStyle = .none
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.makeCornerRadius(10)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return recipeTableView.contentOffset.y >= 100
    }
    
    @objc func closeButtonPressed() {
        navigation.transitionToView(viewControllerType: DietView(), special: nil)
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
    
    func recieve(dish: Dish) {
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
