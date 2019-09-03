//
//  ColorAimView.swift
//  Notes
//
//  Created by Jag Stang on 11/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ColorAimView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let lineWidth: CGFloat = 1
        let wingLength = frame.size.width * 0.2
        let halfWidth = frame.size.width / 2
        let center = CGPoint(x: halfWidth  , y: halfWidth)
        let radius = halfWidth - wingLength
        
        context.setLineWidth(lineWidth)
        UIColor.black.set()
        
        //circle
        context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
        //wings
        context.move(to: CGPoint(x: 0, y: halfWidth))
        context.addLine(to: CGPoint(x: wingLength, y: halfWidth))
        
        context.move(to: CGPoint(x: frame.size.width, y: halfWidth))
        context.addLine(to: CGPoint(x: frame.size.width - wingLength, y: halfWidth))
        
        context.move(to: CGPoint(x: halfWidth, y: 0))
        context.addLine(to: CGPoint(x: halfWidth, y: wingLength))
        
        context.move(to: CGPoint(x: halfWidth, y: frame.size.height))
        context.addLine(to: CGPoint(x: halfWidth, y: frame.size.height - wingLength))
        
        context.strokePath()
    }
}
