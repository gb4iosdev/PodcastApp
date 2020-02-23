//
//  SubscribeButton.swift
//  PodcastApp
//
//  Created by Gavin Butler on 22-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

@IBDesignable
class SubscribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = borderColour.cgColor
        }
    }
    
    private var borderColour: UIColor {
        return isSelected ? Theme.Colours.purpleBright : Theme.Colours.purple
    }

    private func commonSetup() {
        tintColor = Theme.Colours.purple
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = borderColour.cgColor
        layer.masksToBounds = true
        
        let highlightColor = Theme.Colours.purple.withAlphaComponent(0.85)
        setBackgroundImage(UIImage.with(colour: highlightColor), for: .highlighted)
        
        let selectedColour = Theme.Colours.purpleBright
        setBackgroundImage(UIImage.with(colour: selectedColour), for: .selected)
        let bundle = Bundle(for: SubscribeButton.self)
        let checkIcon = UIImage(named: "icon-tick2", in: bundle, compatibleWith: nil)
        setImage(checkIcon, for: .selected)
        setTitleColor(.white, for: .selected)
        
        imageEdgeInsets.left = -20
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 170, height: 46)
    }
    
}
