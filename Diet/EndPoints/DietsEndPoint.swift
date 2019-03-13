//
//  DietsEndPoint.swift
//  Diet
//
//  Created by Даниил on 25/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

enum LanguageCode {
    case english
    case russian
    
    var abbreviation: String {
        switch self {
        case .english: return "en"
        case .russian: return "ru"
        }
    }
}

enum DietApi {
    case diet(type: DietType)
}

extension DietApi: EndPointType {
    
    static var baseUrl: String {
        return "http://dietsforbuddies.com/api/getDiets.php"
    }
    
    var parameters: [String : Any] {
        switch self {
        case .diet(let type):
           // return ["lang": Locale.current.languageCode ?? "", "type":"power"]
            return ["lang": "ru", "type": type.description.lowercased()]
        }
    }
}
