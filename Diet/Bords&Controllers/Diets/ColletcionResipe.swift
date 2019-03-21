//
//  ColletionResipe.swift
//  Diet
//
//  Created by Александр Сенин on 21/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ColletcionResipe: NSObject{
    var cellTapped: ((_ dish: Dish) -> Void)?
    var day: DietWeek.Day!
    var cachedImage = NSCache<AnyObject, AnyObject>()
    var collectionView: UICollectionView!
    var view: UIView!
    let fetchingQueue = DispatchQueue.global(qos: .utility)
    
    init(day: DietWeek.Day, view: UIView) {
        super.init()
        
        self.day = day
        self.view = view
        
        let collectionViewFrame = CGRect(x: 0,
                                         y: view.frame.height,
                                         width: view.frame.width,
                                         height: 250)
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.sectionInset.left = view.frame.width * 0.015
        collectionLayout.sectionInset.right = view.frame.width * 0.015
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.frame = collectionViewFrame
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "DishCell", bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
        
    }

}

extension ColletcionResipe: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
}

extension ColletcionResipe: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped?(day.dishes[indexPath.row])
        
    }
}

extension ColletcionResipe: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day.dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell else {
            print("Could not deque dish cell")
            return UICollectionViewCell()
        }
        
        let dish = day.dishes[indexPath.row]
        
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

