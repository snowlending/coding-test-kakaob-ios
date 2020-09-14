//
//  SearchViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/08.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit
import Alertift

class SearchViewController: UITableViewController, UISearchControllerDelegate {
    
    private var searchController: UISearchController!
    private let searchResultsContainerViewController = SearchResultsContainerViewController()
    private var searchHistory: [String] = SearchHistoryService.shared.all() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var searchType: SearchType = .localHistory
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove the last border of the last cell
        tableView.removeBottomSeparatorLine()
        // Shadow hidden
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        // Translucent navigation bar
        extendedLayoutIncludesOpaqueBars = true

        initSearchController()
        
        // For dev
        // initSampleData()
    }
    
    // Initialize search bar UI
    private func initSearchController() {
        searchController = UISearchController(searchResultsController: searchResultsContainerViewController)
        searchResultsContainerViewController.search = search
        searchResultsContainerViewController.appAction = appAction
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
        guard searchHistory.count == 0 else { return }
        
        let sampleData = ["카카오", "카카오뱅크", "녹음기", "엠넷", "pitu", "의지의 히어로", "구글맵", "진에어", "grab"].reversed()
        sampleData.forEach {SearchHistoryService.shared.add(term: $0)}
        searchHistory = SearchHistoryService.shared.all()
    }
    
    // Search run
    private func search(term: String) {
        searchController.searchBar.text = term
        searchType = .appStore
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
        
        // Make the shadow visible
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        
        // Save search history
        SearchHistoryService.shared.add(term: term)
    }
    
    // Action for app (download or show detail)
    private func appAction(type: AppActionType, app: App) {
        switch type {
        case .download:
            Alertift.alert(title: "다운로드", message: "\(app.name)")
                .action(.default("확인"))
                .show()
        case .showDetail:
            performSegue(withIdentifier: "ShowAppDetailViewSegue", sender: app)
        }
    }
    
    // Screen change using storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAppDetailViewSegue" {
            let appDetailViewController = segue.destination as! AppDetailViewController
            appDetailViewController.modalPresentationStyle = .fullScreen
            appDetailViewController.app = sender as? App
        }        
        crossDissolve()
    }
    
    
    // MARK: UITableView Delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")
        cell?.textLabel?.text = searchHistory[indexPath.row]
        return cell!
    }
    
    // Selected from search history
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(term: searchHistory[indexPath.row])
    }
}



extension SearchViewController: UISearchBarDelegate {
    
    // Typing search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchType = searchText.isEmpty ? .appStore : .localHistory
        navigationController?.navigationBar.setValue(searchText.isEmpty, forKey: "hidesShadow")
    }
    
    // Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        search(term: text)
    }
    
    // Click cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        // Recent search term update
        searchHistory = SearchHistoryService.shared.all()
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
