//
//  String+HTML.swift
//  PodcastApp
//
//  Created by Gavin Butler on 08-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

extension String {
    func strippingHTML() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
