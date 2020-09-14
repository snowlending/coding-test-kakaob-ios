//
//  UIImageView+Extension.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/13.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // Change image tint
    func tintColor(with color: UIColor) {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
    
    func mask(with frame:CGRect) {
        let mask = CALayer()
        mask.frame = frame
        mask.backgroundColor = UIColor.black.cgColor
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    func unmask() {
        layer.mask = nil
        layer.masksToBounds = false

    }
}
