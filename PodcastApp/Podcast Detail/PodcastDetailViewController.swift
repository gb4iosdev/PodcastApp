//
//  PodcastDetailViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit


class PodcastDetailViewController: UITableViewController {
    
    var podcastLookupInfo: PodcastLookupInfo!
    
    private let subscriptionStore = SubscriptionStore.shared
    
    private var podcast: Podcast? {
        didSet {
            podcastViewModel = podcast.flatMap {
                PodcastViewModel(podcast: $0, isSubscribed: subscriptionStore.isSubscribed(to: $0.id))
            }
        }
    }
    
    private var podcastViewModel: PodcastViewModel? {
        didSet {
            headerViewController.podcast = podcastViewModel
            tableView.reloadData()
        }
    }
    
    var headerViewController: PodcastDetailHeaderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Theme.Colours.grey5
        tableView.separatorColor = Theme.Colours.grey3
        
        headerViewController = children.compactMap { $0 as? PodcastDetailHeaderViewController }.first
        headerViewController.subscribeButton.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
        loadPodcast()
    }
    
    private func loadPodcast() {
        let spinner = SpinnerViewController()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        PodcastFeedLoader().fetch(lookupInfo: podcastLookupInfo) { result in
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
            
            switch result {
            case .success(let podcast):
                DispatchQueue.main.async {
                    self.podcast = podcast
                }
            case .failure(let error):
                self.headerViewController.clearUI()
                let alert = UIAlertController(title: "Failed to Load Podcast", message: "Error Loading Feed: \(self.podcastLookupInfo.feedURL.absoluteString): \(error.localizedDescription)", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.loadPodcast()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(retryAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - UITableViewDataSource methods

extension PodcastDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast?.episodes.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCell = tableView.dequeue(for: indexPath)
        
        if let episode = podcast?.episodes[indexPath.row] {
            let viewModel = EpisodeCellViewModel(episode: episode)
            cell.configure(with: viewModel)
        }
        
        return cell
    }
}


//MARK: - Scrolling
extension PodcastDetailViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHeaderParallax(scrollView)
    }
    
    private func adjustHeaderParallax(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let headerView = headerViewController.view
        if offsetY < 0 {
            headerView?.superview?.clipsToBounds = false
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY/10)
            headerView?.alpha = 1.0
        } else {
            headerView?.superview?.clipsToBounds = true
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY/3)
            headerView?.alpha = 1 - (offsetY / headerView!.frame.height * 0.9)
        }
    }
}

//MARK: - Event Handling
extension PodcastDetailViewController {
    
    @objc private func subscribeTapped(_ sender: SubscribeButton) {
        guard let podcast = podcast else { return }
        
        let isSubscribing = !sender.isSelected
        do {
            if isSubscribing {
                try subscriptionStore.subscribe(to: podcast)
            } else {
                try subscriptionStore.unsubscribe(from: podcast)
            }
            sender.isSelected.toggle()
        } catch {
            let action = isSubscribing ? "Subscribing to Podcast" : "Unsubscribing from Podcast"
            let alert = UIAlertController(title: "Error \(action)", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
    }
}
    
