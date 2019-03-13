//
//  FetchingErroService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol FetchincErrorHandler: class {
    
    func fetchingEndedWithError(_ error: Error)
}
