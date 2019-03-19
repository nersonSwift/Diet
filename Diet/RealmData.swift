//
//  RealmData.swift
//  Diet
//
//  Created by Александр Сенин on 15/03/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit
import RealmSwift

class RealmData{
    var realm: Realm!
    var userModel: UserModel!
    
    init(){
        do{
            var config = Realm.Configuration()
            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("UserModel.realm")
            print(config.fileURL!)
            
            realm = try Realm(configuration: config)
            Realm.Configuration.defaultConfiguration = config
            let results = realm.objects(UserModel.self)
            if results.count != 1{
                print(results.count)
                userModel = UserModel()
                try realm.write {
                    realm.add(userModel)
                }
            }else{
                userModel = results[0]
                
            }
            
        }catch{}
    }
}
