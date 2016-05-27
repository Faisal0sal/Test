//
//  Border.swift
//  Test
//
//  Created by F M S ALSALAMAH on 25/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit

enum viewBorder: String {
    case Left = "borderLeft"
    case Right = "borderRight"
    case Top = "borderTop"
    case Bottom = "borderBottom"
}

extension UIView {
    
    func addBorder(vBorder: viewBorder, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.name = vBorder.rawValue
        switch vBorder {
        case .Left:
            border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        case .Right:
            border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
        case .Top:
            border.frame = CGRectMake(0, 0, self.frame.size.width, width)
        case .Bottom:
            border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        }
        self.layer.addSublayer(border)
    }
    
    func removeBorder(border: viewBorder) {
        var layerForRemove: CALayer?
        for layer in self.layer.sublayers! {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
}