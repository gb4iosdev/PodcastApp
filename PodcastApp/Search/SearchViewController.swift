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
    //        SearchResult(artworkUrl: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/95/42/da/9542da30-eaaf-ead9-ac1e-0be9da1931ab/source/200x200bb.png"), title: "The Dropout", author: "ABC News"),
    //        SearchResult(artworkUrl: URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/ce/3d/b4/ce3db4c8-86ba-29ca-8cb0-4cd68388efeb/source/200x200bb.png"), title: "Dirty John", author: "L.A. Times | Wondery")
    
    private var results: [SearchResult] = []
    
    private let recommendedPodcastsClient = TopPodcastsAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Theme.Colours.grey4
        tableView.separatorColor = Theme.Colours.grey3
        tableView.separatorInset = .zero
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        loadRecommendedPodcasts()
    }
    
    private func loadRecommendedPodcasts() {
        recommendedPodcastsClient.fetchTopPodcasts { result in
            switch result {
            case .success(let response):
                self.recommendedPodcasts = response.feed.results.map(SearchResult.init)
                self.results = self.recommendedPodcasts
                self.tableView.reloadData()
            case .failure(let error):
                print("Error loading recommended podcasts: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Search Results Updating
    
    func updateSearchResults(for searchController: UISearchController) {
        
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
