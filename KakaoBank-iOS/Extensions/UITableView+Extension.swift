//
//  UITableView+MainThread.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/13.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

extension UITableView {
    
    // Remove the last border of the last cell
    func removeBottomSeparatorLine() {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 1))
    }
}
