//
//  GradientBackgroundView.swift
//  PodcastApp
//
//  Created by Gavin Butler on 17-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

@IBDesignable
class GradientBackgroundView: UIView {
    
    @IBInspectable var startColour: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var endColour: UIColor = Theme.Colours.grey5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var startLocation: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var endLocation: CGFloat = 0.25 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }
    
    private func commonSetup() {
        backgroundColor = .clear
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colours = [
            startColour.cgColor,
            endColour.cgColor
        ] as CFArray
        
        let locations: [CGFloat] = [startLocation, endLocation]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colours, locations: locations) else {
            UIColor.red.setFill()
            context.fill(rect)
            return
        }
        
        let start = CGPoint.zero
        let end = CGPoint(x: 0, y: rect.height)
        
        context.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }
}
