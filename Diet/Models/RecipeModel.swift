//
//  RecipeModel.swift
//  Diet
//
//  Created by Александр Сенин on 25/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import RealmSwift

class RecipeModel: Object{
    @objc dynamic var nameS: String        = ""
    @objc dynamic var descriptionS: String = ""
    @objc dynamic var imagePathsS: String  = ""
    
    var name : String{
        set(name) {
            try! Realm().write {
                nameS = name
            }
        }
        get{
            return nameS
        }
    }
    
    var descriptioN : String{
        set(descriptioN) {
            try! Realm().write {
                descriptionS = descriptioN
            }
        }
        get{
            return descriptionS
        }
    }
    
    var imagePaths : String{
        set(imagePaths) {
            try! Realm().write {
                imagePathsS = imagePaths
            }
        }
        get{
            return imagePathsS
        }
    }
}
