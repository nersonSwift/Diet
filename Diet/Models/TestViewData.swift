//
//  TestViewData.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

struct TestViewData {
    var title: String
    var iconName: String
    var unit: String?
    var pickerData = [Int]()
    
    init(title: String, iconName: String, pickerData: (startValue: Int, endValue: Int), unit: String? = nil) {
        self.title = title
        self.iconName = iconName
        self.unit = unit
        for i in pickerData.startValue...pickerData.endValue {
            self.pickerData.append(i)
        }
    }
}
