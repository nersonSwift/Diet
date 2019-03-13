//
//  ImageAttachment.swift
//  Diet
//
//  Created by Даниил on 09/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class ImageAttachment: NSTextAttachment {

    var verticalOffset: CGFloat = 0.0

    convenience init(_ image: UIImage, verticalOffset: CGFloat = 0.0) {
        self.init()
        self.image = image
        self.verticalOffset = verticalOffset
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        bounds.origin.x = UIScreen.main.bounds.width / 2
        bounds.size = CGSize(width: 300, height: 200)
        
        return bounds
    }
}
