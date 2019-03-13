//
//  LoadingViewController.swift
//  Diet
//
//  Created by Даниил on 11/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

protocol LoadingTimeoutHandler: class {
    
    func didTimeoutOccured()
}

class LoadingViewController: UIViewController {
    
    weak var timeoutHandler: LoadingTimeoutHandler?
    
    lazy var spinnerContainer: UIView = {
        let view = UIView(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 - 50, width: 100, height: 100))
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        view.addSubview(spinnerContainer)
        spinnerContainer.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: spinnerContainer.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: spinnerContainer.centerYAnchor)
            ])
        
        let timeout = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: timeout) { [weak self] in
            guard let unwrappedSelf = self else { return }
            unwrappedSelf.timeoutHandler?.didTimeoutOccured()
            unwrappedSelf.remove()
        }
    }
}
