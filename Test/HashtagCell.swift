//
//  HashtagCell.swift
//  Test
//
//  Created by F M S ALSALAMAH on 08/06/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit

class HashtagCell: UITableViewCell {
    
    
    let border = CALayer()
    let width = CGFloat(3.0)
    
    
    override func setNeedsLayout() {
        
        border.borderColor = randomColor().CGColor
        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        border.borderWidth = width
        
        self.contentView.layer.addSublayer(border)
        self.contentView.layer.masksToBounds = true
    }
    
    func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   random(),
                       green: random(),
                       blue:  random(),
                       alpha: 1.0)
    }
}