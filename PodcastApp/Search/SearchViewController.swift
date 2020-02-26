//
//  SearchViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 02-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var recommendedPodcasts: [SearchResult] = []
    
    private var results: [SearchResult] = []
    private let dataManager = PodCastDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Theme.Colours.grey4
        tableView.separatorColor = Theme.Colours.grey3
        tableView.separatorInset = .zero
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController!.searchBar.backgroundColor = .black
        
        loadRecommendedPodcasts()
    }
    
    private func loadRecommendedPodcasts() {
        dataManager.recommendedPodcasts { result in
            switch result {
            case .success(let podcastResults):
                self.recommendedPodcasts = podcastResults
                self.results = self.recommendedPodcasts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error loading recommended podcasts: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Search Results Updating
    
    func updateSearchResults(for searchController: UISearchController) {
        let term = searchController.searchBar.text ?? ""
        if !term.isEmpty {
            dataManager.search(for: term) { result in
                switch result {
                    case .success(let searchResults):
                        self.results = searchResults
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("Error searching for podcasts: \(error.localizedDescription)")
                    }
            }
        } else {
            resetToRecommendedPodcasts()
        }
    }
    
    private func resetToRecommendedPodcasts() {
        results = recommendedPodcasts
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeue(for: indexPath)
        let result = results[indexPath.row]
        cell.configure(with: result)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row]
        
            if let feed = result.feedURL {
                DispatchQueue.main.async {
                    self.showPodcast(with: feed)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            } else {
                self.dataManager.lookup(podcastID: result.id) { result in
                    switch result {
                    case .success(let podcast):
                        if let feed = podcast?.feedURL {
                            DispatchQueue.main.async {
                                self.showPodcast(with: feed)
                            }
                        } else {
                            print("Podcast not found")
                        }
                    case .failure(let error):
                        print("Error loading podcast: \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
    }
    
    private func showPodcast(with feedURL: URL) {
        let detailVC = UIStoryboard(name: "PodcastDetail", bundle: nil).instantiateInitialViewController() as! PodcastDetailViewController
        detailVC.feedURL = feedURL
        show(detailVC, sender: self)
    }

}
