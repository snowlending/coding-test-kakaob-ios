//
//  Collection+Extention.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/13.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

extension Collection {

    // Returns the element at the specified index if it is within bounds, otherwise nil.
    // Source https://stackoverflow.com/a/30593673/2715826
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
