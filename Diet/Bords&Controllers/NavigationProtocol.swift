//
//  NavigationProtocol.swift
//  AlarmClock
//
//  Created by Александр Сенин on 22/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

protocol NavigationProtocol{
    var navigation: Navigation! {get set}
    var sub: Bool! {get}
    static func storyboardInstance(navigation: Navigation) -> UIViewController?
}

