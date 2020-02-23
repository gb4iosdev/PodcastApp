//
//  SeparatorView.swift
//  PodcastApp
//
//  Created by Gavin Butler on 19-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit
 
@IBDesignable
class SeparatorView: UIView {
 
    @IBInspectable
    var separatorColour: UIColor = Theme.Colours.grey3 {
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
        isOpaque = false
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        separatorColour.setStroke()
       
        context.setLineWidth(1)
        let midY = bounds.size.height / 2
        context.move(to: CGPoint(x: 0, y: midY))
        context.addLine(to: CGPoint(x: bounds.size.width, y: midY))
        context.strokePath()
    }
}
