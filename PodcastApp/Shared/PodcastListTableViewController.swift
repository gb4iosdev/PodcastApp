//
//  PodcastListTableViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 14-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class PodcastListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Theme.Colours.grey4
        tableView.separatorColor = Theme.Colours.grey3
        tableView.separatorInset = .zero
    }
    
    func showPodcast(with lookupInfo: PodcastLookupInfo) {
        let detailVC = UIStoryboard(name: "PodcastDetail", bundle: nil).instantiateInitialViewController() as! PodcastDetailViewController
        detailVC.podcastLookupInfo = lookupInfo
        show(detailVC, sender: self)
    }

    
}
