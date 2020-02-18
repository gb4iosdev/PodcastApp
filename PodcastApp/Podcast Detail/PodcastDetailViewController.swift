//
//  PodcastDetailViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit


class PodcastDetailViewController: UITableViewController {
    
    var feedURL: URL = URL(string: "https://rss.art19.com/the-shrink-next-door")!
    
    var podcast: Podcast! {
        didSet {
            headerViewController.podcast = podcast
        }
    }
    
    var headerViewController: PodcastDetailHeaderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewController = children.compactMap { $0 as? PodcastDetailHeaderViewController }.first
        
        let spinner = SpinnerViewController()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        
        
        PodcastFeedLoader().fetch(feed: feedURL) { result in
            
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
            
            switch result {
            case .success(let podcast):
                self.podcast = podcast
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
