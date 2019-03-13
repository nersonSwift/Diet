//
//  CGFloatExtention.swift
//  Diet
//
//  Created by Даниил on 01/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

 import UIKit

extension CGFloat {
    static func random(in intervals: [ClosedRange<CGFloat>]) -> CGFloat? {
        return intervals.map { CGFloat.random(in: $0) }.randomElement()?.rounded()
    }
}
