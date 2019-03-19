//
//  UIButtonP.swift
//  GameSenter
//
//  Created by Александр Сенин on 16/02/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class UIButtonP: UIButton{
    var executors: [Executor] = []
    func addClosure(event: UIControl.Event, _ closure : @escaping () -> ()){
        let executor = Executor(closure)
        executors.append(executor)
        self.addTarget(executor, action: #selector(executor.tochBatton), for: event)
    }
}

class Executor{
    private var actionBatton = {}
    
    init( _ closure : @escaping () -> ()){
        actionBatton = closure
    }
    
    @objc func tochBatton(){
        actionBatton()
    }
}
