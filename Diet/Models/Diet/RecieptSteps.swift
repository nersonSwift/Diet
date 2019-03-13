//
//  Recipe.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import AlamofireImage

struct RecieptSteps {
    
    var name: String
    var description: String
    var imagePaths: [String]
    var images = [Image]()
    
    init(name: String, description: String, imagePaths: [String]) {
        self.name = name
        self.description = description
        self.imagePaths = imagePaths
    }
}
