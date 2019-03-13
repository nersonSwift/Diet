//
//  FatnessCategoryCell.swift
//  Diet
//
//  Created by Даниил on 03/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class FatnessCategoryCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    static var identifier = "FatnessCategoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

