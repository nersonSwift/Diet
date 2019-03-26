//
//  DishModel.swift
//  Diet
//
//  Created by Александр Сенин on 25/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import RealmSwift

class DishModel: Object{
    @objc dynamic var nameS: String      = ""
    @objc dynamic var imagePathS: String = ""
    
    @objc dynamic var caloriesS: Double  = 0.0
    @objc dynamic var proteinS: Double   = 0.0
    @objc dynamic var carbsS: Double     = 0.0
    @objc dynamic var fatsS: Double      = 0.0
    let recipe = List<RecipeModel>()

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
    
    var imagePath : String{
        set(imagePath) {
            try! Realm().write {
                imagePathS = imagePath
            }
        }
        get{
            return imagePathS
        }
    }
    
    var calories : Double{
        set(calories) {
            try! Realm().write {
                caloriesS = calories
            }
        }
        get{
            return caloriesS
        }
    }
    
    var protein : Double{
        set(protein) {
            try! Realm().write {
                proteinS = protein
            }
        }
        get{
            return proteinS
        }
    }
    
    var carbs : Double{
        set(carbs) {
            try! Realm().write {
                carbsS = carbs
            }
        }
        get{
            return carbsS
        }
    }
    
    var fats : Double{
        set(fats) {
            try! Realm().write {
                fatsS = fats
            }
        }
        get{
            return fatsS
        }
    }
    
    func save(){
        try! Realm().write {
            try! Realm().add(self)
        }
    }
    func del(){
        try! Realm().write {
            try! Realm().delete(self)
        }
    }
}
