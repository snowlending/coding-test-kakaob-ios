//
//  SearchedTermTableViewCell.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/09.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class SearchedTermTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func set(term: String, searchedTerm: String) {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.gray]
        let attributedString = NSAttributedString(string: term.lowercased(), attributes: attributes)
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        
        label.attributedText = mutableAttributedString
    }
    
}

extension NSMutableAttributedString {
    
    public func setBold(text: String) {
        let foundRange = mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.black,
                range: foundRange
            )
        }
    }
    
}
