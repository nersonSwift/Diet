//
//  WeekRationCell.swift
//  Diet
//
//  Created by Даниил on 07/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WeekRationCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier = "WeekRationCell"
    let fetchingQueue = DispatchQueue.global(qos: .utility)
    var cachedImage = NSCache<AnyObject, AnyObject>()
    var cellTapped: ((_ dish: Dish) -> Void)?
    var weekDishes: [Dish]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DishCell", bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
    }
}

extension WeekRationCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
}

extension WeekRationCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped?(weekDishes[indexPath.row])
    }
}

extension WeekRationCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dishes = weekDishes else { return 0 }
        return dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell else {
            print("Could not deque dish cell")
            return UICollectionViewCell()
        }
        
        let dish = weekDishes[indexPath.row]
        
        cell.dishNameLabel.text = dish.name
        cell.dishCaloriesLabel.text = "\(dish.nutritionValue.calories)" + " kCal.".localized
        
        cell.dishImageView.image = nil
        if let imageFromCache = cachedImage.object(forKey: dish.imagePath as AnyObject) as? UIImage {
            cell.dishImageView.image = imageFromCache
            return cell
        }
        
        fetchingQueue.async {
            request(dish.imagePath, method: .get).responseImage { (response) in
                guard let image = response.result.value else {
                    DispatchQueue.main.async {
                        cell.dishImageView.image = UIImage(named: "no_food")
                    }
                    print("Image for dish  - \(dish.name) is NIL")
                    return
                }
                DispatchQueue.main.async {
                    cell.dishImageView.image = image
                    self.cachedImage.setObject(image, forKey: dish.imagePath as AnyObject)
                }
            }
        }
        return cell
    }
}
