//
//  UIViewController+Child.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/09.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//  Source https://www.swiftbysundell.com/basics/child-view-controllers/
//

import UIKit

extension UIViewController {
    
    // Add child
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    // Remove child
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
