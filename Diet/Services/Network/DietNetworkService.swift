//
//  DietNetworkService.swift
//  Diet
//
//  Created by Даниил on 19/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol DietNetworkServiceDelegate: FetchincErrorHandler {
    
    func dietNetworkServiceDidGet(_ diet: Diet)
}

protocol DietNetworkService {
    
    var dietServiceDelegate: DietNetworkServiceDelegate? { get set }
    func getDiet(_ type: DietType)
}
