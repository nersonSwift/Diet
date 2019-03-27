//
//  UserModel.swift
//  Diet
//
//  Created by Александр Сенин on 15/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import RealmSwift

class UserModel: Object{
    @objc dynamic var ageS = 0
    @objc dynamic var currentWeightS = 0
    @objc dynamic var genderS = false
    @objc dynamic var heightS = 0
    @objc dynamic var obesityIndextS = 0
    @objc dynamic var obesityTypeS = ""
    @objc dynamic var trialS = true
    @objc dynamic var subS = true
    @objc dynamic var obesityTypeSelectS = ""
    
    var age : Int{
        set(age) {
            try! Realm().write {
                ageS = age
            }
        }
        get{
            return ageS
        }
    }
    
    var currentWeight : Int{
        set(currentWeight) {
            try! Realm().write {
                currentWeightS = currentWeight
            }
        }
        get{
            return currentWeightS
        }
    }
    
    var gender : Bool{
        set(gender) {
            try! Realm().write {
                genderS = gender
            }
        }
        get{
            return genderS
        }
    }
    
    var height : Int{
        set(height) {
            try! Realm().write {
                heightS = height
            }
        }
        get{
            return heightS
        }
    }
    
    var obesityIndext : Int{
        set(obesityIndext) {
            try! Realm().write {
                obesityIndextS = obesityIndext
            }
        }
        get{
            return obesityIndextS
        }
    }
    
    var obesityType : String{
        set(obesityType) {
            print(obesityType)
            
            try! Realm().write {
                obesityTypeS = obesityType
            }
        }
        get{
            return obesityTypeS
        }
    }
    
    var obesityTypeSelect : String{
        set(obesityTypeSelect) {
            
            try! Realm().write {
                obesityTypeSelectS = obesityTypeSelect
            }
        }
        get{
            return obesityTypeSelectS
        }
    }
    
    var trial : Bool{
        set(trial) {
            try! Realm().write {
                trialS = trial
            }
        }
        get{
            return trialS
        }
    }
    
    var sub : Bool{
        set(sub) {
            try! Realm().write {
                subS = sub
            }
        }
        get{
            return subS
        }
    }
}
