//
//  UIImage+Colour.swift
//  PodcastApp
//
//  Created by Gavin Butler on 22-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

extension UIImage {
    static func with(colour: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            colour.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
