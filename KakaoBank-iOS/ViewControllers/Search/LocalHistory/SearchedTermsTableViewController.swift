//
//  SearchedTermsTableViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/09.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class SearchedTermsTableViewController: UITableViewController {
    
    private var terms = [String]()
    var searchedTerm = String() {
        didSet {
            // Filter search results
            terms = SearchHistoryService.shared.all().filter{$0.lowercased().hasPrefix(searchedTerm.lowercased())}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var search: (String) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedTermTableViewCell", for: indexPath) as! SearchedTermTableViewCell
        cell.set(term: terms[indexPath.row],
                 searchedTerm: searchedTerm)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(terms[indexPath.row])
    }
}
