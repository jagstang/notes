//
//  GradientColorSelectorView.swift
//  Notes
//
//  Created by Jag Stang on 10/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class GradientColorView: UIView {
    
    private let elementSize: CGFloat = 3
    
    public var brightness: CGFloat = 1 {
        didSet {
            if oldValue != self.brightness {
                setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for y: CGFloat in stride(from: 0.0, to: rect.height, by: elementSize) {
            let saturation = 1 - y / rect.height
            for x: CGFloat in stride(from: 0.0, to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: y, width: elementSize, height: elementSize))
                
            }
        }
        
    }
    
    public func updateBy(color: UIColor) -> CGPoint? {
        let rect = bounds.size
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        self.brightness = brightness
        let x = hue * rect.width
        let y = (1 - saturation) * rect.height
        
        if x >= 0 && x <= rect.width && y >= 0 && y <= rect.height {
            return CGPoint(x: x, y: y)
        }
        
        return nil
    }
    
    public func getColorBy(point: CGPoint) -> UIColor? {
        let rect = self.frame
        
        let hue: CGFloat = point.x / rect.width
        let saturation: CGFloat = 1 - point.y / rect.height
        return UIColor(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: 1.0
        )
    }
}
