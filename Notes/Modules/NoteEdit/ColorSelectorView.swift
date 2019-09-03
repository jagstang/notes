//
//  ColorSelectorView.swift
//  Notes
//
//  Created by Jag Stang on 09/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorSelectorView: UIView {

    public var id: Int?
    
    public var isSelected = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        if isSelected {
            let lineWidth: CGFloat = 2
            context.setLineWidth(lineWidth)
            UIColor.black.set()
            let center = CGPoint(x: frame.size.width * 0.70  , y: frame.size.height * 0.3)
            let radius = (frame.size.width * 0.4) / 2
            //circle
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            //mark
            context.move(to: CGPoint(x: center.x - radius + lineWidth * 2, y: center.y))
            context.addLine(to: CGPoint(x: center.x, y: center.y + radius - lineWidth * 2))
            context.addLine(to: CGPoint(x: center.x + radius * 0.5, y: center.y - radius + lineWidth * 2))

            context.strokePath()
        }
    }
}
