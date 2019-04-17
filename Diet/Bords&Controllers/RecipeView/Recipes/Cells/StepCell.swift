//
//  StepCell.swift
//  Diet
//
//  Created by Даниил on 08/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var stepDescriptionLabel: UILabel!
    @IBOutlet weak var stepImageView: UIImageView!
    
    static var identifier = "StepCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        stepImageView.layer.cornerRadius = 10
        stepImageView.layer.masksToBounds = true
    }
}
