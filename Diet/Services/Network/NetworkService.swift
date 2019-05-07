//
//  NetworkService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class NetworkService {
    
    weak var dietServiceDelegate: DietNetworkServiceDelegate?
    weak var errorHandler: FetchincErrorHandler?
    fileprivate let downloader = ImageDownloader(configuration: .default, downloadPrioritization: .fifo, maximumActiveDownloads: 5, imageCache: nil)
    fileprivate let imageBaseUrl = "http://dietsforbuddies.com/newImage/"
    fileprivate let daysOfWeek = ["Monday","Tuesday",
                                  "Wednesday","Thursday",
                                  "Friday","Saturday",
                                  "Sunday"]
    init() {}
    
    fileprivate func setDishesImagePaths(for dietDays: inout [DietWeek.Day], dietType: String) {
        
        let separator = "/"
    
        for i in 0..<dietDays.count {
            for j in 0..<dietDays[i].dishes.count {
                let newPath = imageBaseUrl + dietType + separator + daysOfWeek[i] + separator + "dishes\(j + 1)" + separator + "image.jpg"
                dietDays[i].dishes[j].imagePath = newPath
            }
        }
    }
    
    fileprivate func setRecipesImagesPaths(for dietDays: inout [DietWeek.Day], dietType: String) {
        
        let separator = "/"
        
        for i in 0..<dietDays.count {
            for j in 0..<dietDays[i].dishes.count {
                for k in 0..<dietDays[i].dishes[j].recipe.count {
                    let newPath = imageBaseUrl + dietType + separator + daysOfWeek[i] + separator + "dishes\(j + 1)" + separator + "step\(k).jpg"
                    dietDays[i].dishes[j].recipe[k].imagePaths[0] = newPath
                }
            }
        }
    }
}

// MARK: - DietNetworkService
extension NetworkService: DietNetworkService {
    
    func getDiet(_ type: DietType) {
        
        let queue = DispatchQueue.global(qos: .utility)
        //let parameters = DietApi.diet(type: type).parameters
        
        print(DietApi.baseUrl)
        var count = 0
        var locale = NSLocale.preferredLanguages.first!.filter { (a) -> Bool in
            if count <= 1{
                count += 1
                return true
            }
            return false
        }
        print(locale)
        if locale != "ru"{
            locale = "en"
        }
        
        request(DietApi.baseUrl).response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { [weak self] response in
                
            guard let unwrappedSelf = self else { print("self is nil"); return }
            
            guard let responseValue = response.result.value else {
                print("Diet raw json is nil")
                return
            }
            
            let json = JSON(responseValue)[type.description]
            let json1 = JSON(responseValue)[type.description]
            
            var days1: [DietWeek.Day] = []{
                didSet {
                    print(days1.count)
                    if days1.count == 7{
                        let diet = Diet.init(name: "",
                                             description: "",
                                             type: type.description,
                                             weeks: [DietWeek.init(nutritionalValue: NutritionalValue(calories: 0,
                                                                                                      protein: 0,
                                                                                                      carbs: 0,
                                                                                                      fats: 0),
                                                                   days: days1)])
                        
                        unwrappedSelf.dietServiceDelegate?.dietNetworkServiceDidGet(diet)
                    }
                }
            }
            
            for i in unwrappedSelf.daysOfWeek{
                var dishes1: [Dish] = []{
                    didSet {
                        if dishes1.count == json1[i].array!.count{
                            print(i)
                            let day = DietWeek.Day(name: i,
                                                   dishes: dishes1)
                            days1.append(day)
                        }else{
                            print("\(i) - \(dishes1.count)/\(json1[i].array!.count) - \(dishes1.last!.name)")
                        }
                    }
                }
                for resId in json1[i]{
                    request("http://dietsforbuddies.com/NewApi/id/id\(resId.1.string!).json").response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { response in
                        
                        guard let responseValue = response.result.value else {
                            print("http://dietsforbuddies.com/NewApi/id/id\(resId.1.string!).json ++")
                            return
                        }
                        let jsonId = JSON(responseValue)
                        var translit = jsonId[locale]
                        //print(translit)
                        //print(translit["reciept"])
                        
                        var recieptSteps: [RecieptSteps] = []
                        if translit["reciept"].array == nil{
                            print("\(jsonId["id"]) --")
                            print("http://dietsforbuddies.com/NewApi/id/id\(resId.1.string!).json ++")
                            return
                        }
                        for j in 0..<translit["reciept"].array!.count{
                            let recieptStep = RecieptSteps(name: translit["reciept"][j]["name"].string!,
                                                           description: translit["reciept"][j]["description"].string!,
                                                           imagePaths: [jsonId["steps"][j]["step\(j+1)"].string!])
                            recieptSteps.append(recieptStep)
                        }
                        let dish = Dish(name: translit["name"].string!,
                                        imagePath: "http://dietsforbuddies.com/NewApi/Image/image\(resId.1.string!).jpg",
                                        nutritionValue: NutritionalValue(calories: Double(jsonId["calories"].string!)!,
                                                                         protein:  Double(jsonId["protein"].string!)!,
                                                                         carbs:    Double(jsonId["carbs"].string!)!,
                                                                         fats:     Double(jsonId["fats"].string!)!),
                                        recipe: recieptSteps)
                        print(dish.name)
                        DispatchQueue.main.async {
                            dishes1.append(dish)
                        }
                    }
                }
            }
        }
    }
}

extension NetworkService: ImageNetworkService {
    func fetchImages(with paths: [String], completion: @escaping (RequestResult<[String : Image]>) -> ()) {
        
        var images = [String:Image]()
        let group = DispatchGroup()
        
        for path in paths {
            
            guard let url = URL(string: path) else { return }
            let urlRequest = URLRequest(url: url)
            group.enter()
            
            downloader.download(urlRequest) { (response) in
                
                switch response.result {
                case .success(_):
                    if let image = response.result.value {
                        images[path] = image
                        group.leave()
                    }
                case .failure(let error):
                    completion(.failure(error: error))
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(result: images))
        }
    }
}
