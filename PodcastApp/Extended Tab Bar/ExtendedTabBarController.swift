//
//  ExtendedTabBarController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 13-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class ExtendedTabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let player = PlayerViewController.shared
        player.presentationRootController = self
        
        let playerBar = player.playerBar
        
        //Install this in the tab bar
        (tabBar as? ExtendedTabBar)?.playerBar = playerBar
        
    }
}
