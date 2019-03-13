//
//  ImageNetworkService.swift
//  Diet
//
//  Created by Даниил on 10/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import AlamofireImage

enum RequestResult<T> {
    case success(result: T)
    case failure(error: Error)
}

protocol ImageNetworkService: class {
    
    var errorHandler: FetchincErrorHandler? { get set }
    
    func fetchImages(with paths: [String], completion: @escaping (RequestResult<[String:Image]>) -> ())
}
