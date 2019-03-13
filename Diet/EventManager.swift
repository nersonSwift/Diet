//
//  EventManager.swift
//  Diet
//
//  Created by Даниил on 18/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import AppsFlyerLib

class EventManager {
    
    static func sendEvent(with title: String) {
        AppsFlyerTracker.shared()?.trackEvent(title, withValues: [:])
    }
}
