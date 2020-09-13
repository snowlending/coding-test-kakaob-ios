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
    private var searchHistory: [String] = SearchHistoryHelper.shared.all()
    private var searchType: SearchType = .history
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove the last border of the last cell
        tableView.removeBottomSeparatorLine()
        // Shadow hidden
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        // Translucent navigation bar
        extendedLayoutIncludesOpaqueBars = true

        initSearchController()
        
        initSampleData()
        
        test()
    }
    
    func test() {        
        
//        let term = "카카오뱅크"
//        print(ItunesAPI.shared.getURL(with: "search"))
//        let term = "카카오뱅크"
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "itunes.apple.com"
//        urlComponents.path = "/search"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "term", value: term),
//            URLQueryItem(name: "country", value: "KR"),
//            URLQueryItem(name: "entity", value: "software"),
//            URLQueryItem(name: "lang", value: "ko_KR"),
//            URLQueryItem(name: "explicit", value: "NO"),
//            URLQueryItem(name: "limit", value: "200"),
//        ]
//
//        let url = urlComponents.url!
//        var session = URLSession.shared
//        let configuration = URLSessionConfiguration.default
//        // See additional explanation
//        // https://github.com/Alamofire/Alamofire/issues/1266#issuecomment-221471947
//        configuration.timeoutIntervalForRequest = 7
//        configuration.timeoutIntervalForResource = 30
//        session = URLSession(configuration: configuration)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            if error != nil || data == nil {
//                print("클라이언트 에러가 있습니다.")
//                DispatchQueue.main.async {
//                    Alertift.alert(title: "네트워크 에러", message: "클라이언트 에러가 있습니다.")
//                        .action(.default("확인"))
//                        .show(on: self)
//                }
//                return
//            }
//
//            guard let resp = response as? HTTPURLResponse, (200...299).contains(resp.statusCode) else {
//                print("서버 에러가 있습니다.\n코드: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
//                DispatchQueue.main.async {
//                    Alertift.alert(title: "네트워크 에러", message: "서버 에러가 있습니다.\n코드: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
//                        .action(.default("확인"))
//                        .show()
//                }
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print(json)
//            } catch {
//                print("JSON error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    Alertift.alert(title: "데이터 에러", message: "데이터에 에러가 있습니다.\n메세지: \(error.localizedDescription)")
//                        .action(.default("확인"))
//                        .show(on: self)
//                }
//            }
//
//        })
//
//        task.resume()
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
        tableView.reloadOnMainThread()
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
        tableView.reloadOnMainThread()
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
