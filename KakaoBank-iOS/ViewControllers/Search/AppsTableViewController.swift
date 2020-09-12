//
//  AppsTableViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/11.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {
    
    var apps = [App]()
    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchedTermTableViewCell
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 이미지 로딩 취소
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
}
