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
    
    
    private let searchClient = PodcastSearchAPI()

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
        recommendedPodcastsClient.fetchTopPodcasts { result in
            switch result {
            case .success(let response):
                self.recommendedPodcasts = response.feed.results.map(SearchResult.init)
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
            searchClient.search(for: term) { result in
                switch result {
                case .success(let response):
                    self.results = response.results.map(SearchResult.init)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
