//
//  SKProductExtension.swift
//  Diet
//
//  Created by Даниил on 06/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import StoreKit

@available(iOS 11.2, *)
extension SKProduct.PeriodUnit {
    func description(capitalizeFirstLetter: Bool = false, numberOfUnits: Int? = nil) -> String {
        
        let period:String = {
            switch self {
            case .day: return "day".localized
            case .week: return "week".localized
            case .month: return "month".localized
            case .year: return "year".localized
            }
        }()
        
        var numUnits = ""
        var plural = ""
        if let numberOfUnits = numberOfUnits {
            numUnits = "\(numberOfUnits) "
            plural = numberOfUnits > 1 ? "s" : ""
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)\(plural)"
    }
}
