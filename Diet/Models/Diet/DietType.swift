//
//  DietType.swift
//  Diet
//
//  Created by Даниил on 11/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

enum DietType: String {
    
    case daily = "Daily"
    case power = "Power"
    case superFit = "Superfit"
    case fit = "Fit"
    case balance = "Balance"
    
    var description: String {
        switch self {
        case .daily:
            return "Daily"
        case .power:
            return "Power"
        case .superFit:
            return "Superfit"
        case .fit:
            return "Fit"
        case .balance:
            return "Balance"
        }
    }
}
