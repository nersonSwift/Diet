//
//  DietWeek.swift
//  Diet
//
//  Created by Даниил on 17/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

struct DietWeek {
    
    struct Day {
        var name: String
        var dishes: [Dish]
    }
    
    var nutritionalValue: NutritionalValue
    var days: [Day]
}
