//
//  DietViewController.swift
//  Diet
//
//  Created by Даниил on 06/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class DietViewController: UIViewController {
    
    @IBOutlet weak var dietBackImageView: UIImageView!
    @IBOutlet weak var dietNameLabel: UILabel!
    @IBOutlet weak var dietDescriptionLabel: UILabel!
    @IBOutlet weak var dietDescriptionView: UIView!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var rationsTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight: CGFloat = 1200
    fileprivate let viewCornerRadius: CGFloat = 32.0
    var accessStatus = AccessStatus.available
    var bodyCategory: CategoryName!
    fileprivate let daysOfWeek = ["Monday".localized,"Tuesday".localized,
                                  "Wednesday".localized,"Thursday".localized,
                                  "Friday".localized,"Saturday".localized,
                                  "Sunday".localized]
    
    let gramMeasure = "g.".localized
    let caloriesMesure = "kCal.".localized
    weak var recipeSender: RecipeReciver?
    let dropDownMenu = DropDown()
    private var previousStatusBarHidden = false
    fileprivate var diet: Diet! {
        didSet {
            dietDescriptionView.layoutIfNeeded()
        }
    }
    fileprivate var dishes = [Dish]()
    fileprivate let fetchingQueue = DispatchQueue.global(qos: .utility)
    let networkService = NetworkService()
    let loadingVc = LoadingViewController()
    
    private var visibleRect: CGRect {
        get {
            return CGRect(x: 0.0,
                          y: topScrollView!.contentOffset.y,
                          width: topScrollView!.frame.size.width,
                          height: topScrollView!.frame.size.height)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRecipe" {
            if let destinationVc = segue.destination as? RecipeViewController {
                recipeSender = destinationVc
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        networkService.dietServiceDelegate = self
        EventManager.sendEvent(with: "Diet screen opened")
        
        if let bodyCategory = self.bodyCategory {
            getDiet(for: bodyCategory)
        } else {
            if let categoryFromStorage = fetchCategory() {
                getDiet(for: categoryFromStorage)
            } else {
                networkService.getDiet(.balance)
            }
        }
        
        add(loadingVc)
    }
    
    fileprivate func getDiet(for bodyCategory: CategoryName) {
        
        switch bodyCategory {
        case .underweight:
            networkService.getDiet(.power)
        case .normal:
            networkService.getDiet(.balance)
        case .excessObesity:
            networkService.getDiet(.daily)
        case .obesity:
            networkService.getDiet(.fit)
        case .severeObesity:
            networkService.getDiet(.superFit)
        case .undefined:
            networkService.getDiet(.balance)
        }
    }
    
    fileprivate func fetchCategory() -> CategoryName? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Test", in: managedContext)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Test")
        fetchRequest.entity = entityDescription
        
        do {
            if let testResultManagedObject = try managedContext.fetch(fetchRequest).last {
                guard let obesityType = testResultManagedObject.value(forKey: "obesityType") as? String else {
                    return nil
                }
                return CategoryName(rawValue: obesityType)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    fileprivate func showContent() {
        
    }
    
    fileprivate func setupView() {
        
        dietDescriptionLabel.text = "..."
        dietNameLabel.text = "..."
        
        if #available(iOS 11.0, *) {
            topScrollView.contentInsetAdjustmentBehavior = .never
        }
        dietBackImageView.contentMode = .scaleAspectFill
        dietBackImageView.clipsToBounds = true
        tableHeightConstraint.constant = self.view.frame.height + 20
        rationsTableView.separatorStyle = .none
        rationsTableView.dataSource = self
        rationsTableView.delegate = self
        rationsTableView.isScrollEnabled = false
        topScrollView.bounces = false
        rationsTableView.register(UINib(nibName: "WeekRationCell", bundle: nil), forCellReuseIdentifier: WeekRationCell.identifier)
        topScrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dietDescriptionView.dropShadow(color: .lightGray, opacity: 0.6, offSet: CGSize(width: 2, height: 1), radius: 8, scale: true)
        dietDescriptionView.layer.cornerRadius = 15
    }
}

extension DietViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return daysOfWeek[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRationCell.identifier, for: indexPath) as? WeekRationCell else {
            print("Could not deque cell")
            return UITableViewCell()
        }
        
        if let unwrppedDiet = diet, let week = unwrppedDiet.weeks.first {
            dishes = week.days[indexPath.section].dishes
            cell.weekDishes = dishes
            cell.cellTapped = { [weak self] (dish) in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showRecipe", sender: self)
                self.recipeSender?.recieve(dish: dish)
            }
        }
        return cell
    }
}

extension DietViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: view.frame.midY - 15, width: view.frame.width - 40, height: 30))
        view.addSubview(label)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)!
        label.text = daysOfWeek[section]
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension DietViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView === self.topScrollView {
            self.topScrollView.bounces = (scrollView.contentOffset.y <= rationsTableView.frame.minY)
            rationsTableView.isScrollEnabled = (scrollView.contentOffset.y >= rationsTableView.frame.minY)
        } else {
            rationsTableView.isScrollEnabled = (scrollView.contentOffset.y > 0)
            rationsTableView.bounces = (scrollView.contentOffset.y != 0)
        }
    }
}

extension DietViewController: DietNetworkServiceDelegate {
    
    func dietNetworkServiceDidGet(_ diet: Diet) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.loadingVc.remove()
            self.dietNameLabel.text = diet.name
            self.dietDescriptionLabel.text = diet.description
            self.diet = diet
            if let dishes = diet.weeks.first?.days.first?.dishes {
                self.dishes = dishes
                self.rationsTableView.reloadData()
                
            }
        }
    }
    
    func fetchingEndedWithError(_ error: Error) {
        
    }
}

extension DietViewController: ContentAccessHandler {
    
    func accessIsDenied() {
        accessStatus = .denied
        let subscriptionOfferVc = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
        present(subscriptionOfferVc, animated: true, completion: nil)
    }
    
    func accessIsAvailable() {
        accessStatus = .available
        showContent()
    }
}
