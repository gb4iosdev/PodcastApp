//
//  ParameterKey.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//List of parameter keys that can be used in this application, and their query string representations.
enum ParameterKey: String {
    //For Search:
    case country
    case media
    case entity
    case attribute
    case searchTerm = "term"
    case id
}
