//
//  AppsTableViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/11.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit
import Alertift

class AppsTableViewController: UITableViewController {
    
    var apps = [App]()
    var dataTask: URLSessionDataTask?
    var loadingIndicator: UIActivityIndicatorView!
    var lbMessage: UILabel!
    var safeArea: UILayoutGuide!
    var appAction: (AppActionType, App) -> Void = { _,_  in }

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        initLoadingIndicator()
        initMessageLabel()
        loadingIndicator.startAnimating()
        lbMessage.isHidden = true
    }
    
    // Initialize display while loading
    func initLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = ColorCompatibility.systemGray2
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    }
    
    // Initialize message label
    func initMessageLabel() {
        lbMessage = UILabel()
        lbMessage.textColor = ColorCompatibility.systemGray
        lbMessage.text = "검색 결과가 없습니다"
        lbMessage.numberOfLines = 1
        view.addSubview(lbMessage)
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        lbMessage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        lbMessage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        lbMessage.textAlignment = .center
    }
    
    // Invisible while loading
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // Show no search results message
    func showMessage() {
        DispatchQueue.main.async {
            self.lbMessage.isHidden = false
        }
    }
    
    // API search
    func search(term: String) {
        dataTask?.cancel()
        dataTask = ItunesAPI.shared.searchApp(term: term, { code, data, error in
            self.hideLoadingIndicator()
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // disregard
                } else {
                    print("Error: \(error!)")
                    DispatchQueue.main.async {
                        Alertift.alert(title: "네트워크 에러", message: "클라이언트 에러가 있습니다.\n\n에러 메세지\n\(error!.localizedDescription)")
                            .action(.default("확인"))
                            .show()
                    }
                }
                return
            }
            guard (200...299).contains(code) else {
                print("Server Error: \(code)")
                DispatchQueue.main.async {
                    Alertift.alert(title: "네트워크 에러", message: "서버 에러가 있습니다.\n\n에러 코드 \(code)")
                        .action(.default("확인"))
                        .show()
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(AppResponse.self, from: data)
                guard response.resultCount != 0 else {
                    self.showMessage()
                    return
                }
                self.handle(response: response)
            } catch {
                print("Data Error: \(error)")
                DispatchQueue.main.async {
                    Alertift.alert(title: "네트워크 에러", message: "데이터에 문제가 있습니다.\n\n에러 메세지\n\(error.localizedDescription)")
                        .action(.default("확인"))
                        .show()
                }
                return
            }
        })
    }
    
    // Handling search results
    func handle(response: AppResponse) {
        apps = response.results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppTableViewCell", for: indexPath) as! AppTableViewCell
        cell.set(app: apps[indexPath.row])
        // Tap app download button
        cell.downloadActionBlock = {
            self.appAction(.download, self.apps[indexPath.row])
        }
        return cell
    }
    
    // Selected app
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appAction(.showDetail, apps[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
}
