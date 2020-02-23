//
//  Theme.swift
//  PodcastApp
//
//  Created by Gavin Butler on 02-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit
 
struct Theme {
    
    static func apply(to window: UIWindow) {
        window.tintColor = Colours.purple
                                
        //Returns a Tab Bar proxy – everything done to this Tab Bar will apply to all in the app.
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = Colours.grey4
 
        //Returns a NavigationBar proxy – everything done to this Navigation Bar will apply to all in the app.
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Colours.grey4
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colours.grey0]
        
        let searchBarTextFields = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarTextFields.defaultTextAttributes = [
            .foregroundColor : Colours.grey1,
            .font : UIFont.boldSystemFont(ofSize: 14)
        ]
    }
 
    struct Colours {
        static let grey0 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.85, alpha: 1.0)
        static let grey1 = UIColor(hue: 0.67, saturation: 0.03, brightness: 0.58, alpha: 1.0)
        static let grey2 = UIColor(hue: 0.67, saturation: 0.08, brightness: 0.33, alpha: 1.0)
        static let grey3 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.15, alpha: 1.0)
        static let grey4 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.11, alpha: 1.0)
        static let grey5 = UIColor(hue: 0.75, saturation: 0.10, brightness: 0.08, alpha: 1.0)
        static let purple = UIColor(hue: 0.73, saturation: 0.78, brightness: 0.98, alpha: 1.0)
        static let purpleLight = UIColor(hue: 0.70, saturation: 0.28, brightness: 0.71, alpha: 1.0)
        static let purpleBright = UIColor(red: 0.63, green: 0.006, blue: 1.00, alpha: 1.00)
    }
}
