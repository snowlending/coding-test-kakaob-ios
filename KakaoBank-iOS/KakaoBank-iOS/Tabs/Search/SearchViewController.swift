//
//  SearchViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/08.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchControllerDelegate {
    
    private var searchController: UISearchController!
    private let searchResultsContainerViewController = SearchResultsContainerViewController()
    private var searchHistory: [String] = SearchHistoryHelper.shared.all()
    private var searchType: SearchType = .history
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove the last border of the last cell
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        // Shadow hidden
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        // Translucent navigation bar
        extendedLayoutIncludesOpaqueBars = true

        initSearchController()
        
        initSampleData()
    }
    
    // Initialize search bar UI
    private func initSearchController() {
        searchController = UISearchController(searchResultsController: searchResultsContainerViewController)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // Sample data for development testing
    private func initSampleData() {
        let sampleData = ["카카오", "카카오뱅크", "녹음기", "엠넷", "pitu", "의지의 히어로", "구글맵", "진에어", "grab"].reversed()
        sampleData.forEach {SearchHistoryHelper.shared.add(term: $0)}
        searchHistory = SearchHistoryHelper.shared.all()
        tableView.reloadData()
    }
    
    // Search run
    private func search(term: String) {
        searchController.searchBar.text = term
        searchType = .appstore
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
        
        // Make the shadow visible
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        
        // Save search history
        SearchHistoryHelper.shared.add(term: term)
        
        // Recent search term update
        searchHistory = SearchHistoryHelper.shared.all()
        tableView.reloadData()
    }
    
    
    // MARK: UITableView Delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = searchHistory[indexPath.row]
        return cell!
    }
    
    
    // MARK: UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(term: searchHistory[indexPath.row])
    }
}



extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchType = searchText.isEmpty ? .appstore : .history
        navigationController?.navigationBar.setValue(searchText.isEmpty, forKey: "hidesShadow")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        search(term: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
}



extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        searchResultsContainerViewController.handle(term: text, searchType: searchType)
    }
    
}
