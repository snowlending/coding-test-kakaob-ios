//
//  SearchResultContainerViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/10.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class SearchResultsContainerViewController: UIViewController {
    
    var shownViewController: UIViewController?
    private var searchedTermsTableViewController: SearchedTermsTableViewController!
    var search: (String) -> Void = { _ in }
    var appAction: (AppActionType, App) -> Void = { _,_  in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        searchedTermsTableViewController = storyboard.instantiateViewController(withIdentifier: "SearchedTermsTableViewController") as? SearchedTermsTableViewController
        searchedTermsTableViewController.search = search
    }
    
    // Search Results Update Handler
    func handle(term: String, searchType: SearchType) {
        switch searchType {
        case .localHistory:
            searchedTermsTableViewController.searchedTerm = term
            transition(to:searchedTermsTableViewController)
        case .appStore:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let appsListViewController = storyboard.instantiateViewController(withIdentifier: "AppsTableViewController") as? AppsTableViewController
            appsListViewController?.search(term: term)
            appsListViewController?.appAction = appAction
            transition(to:appsListViewController!)
        }
    }
    
    // Switch screen within container (SearchedTermsTableView or AppsTableView)
    func transition(to viewController: UIViewController) {
        guard viewController != shownViewController else { return }
        shownViewController?.remove()
        add(viewController)
        shownViewController = viewController
    }
    
}
