//
//  TestResult.swift
//  Diet
//
//  Created by Даниил on 28/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

enum CategoryName: String {
    case underweight
    case normal
    case excessObesity
    case obesity
    case severeObesity
    case undefined
}

struct TestResult {
    var age = 0
    var currentWeight = 0
    var goalWeight = 0
    var height = 0
    var gender = Gender.undefined
    var fatnessCategory = CategoryName.undefined
    
    init() {}
}
