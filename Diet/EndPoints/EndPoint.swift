//
//  EndPoint.swift
//  Diet
//
//  Created by Даниил on 25/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol EndPointType {
    static var baseUrl: String { get }
    var parameters: [String:Any] { get }
}
