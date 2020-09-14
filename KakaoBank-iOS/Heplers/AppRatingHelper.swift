//
//  AppRatingHelper.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/14.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class AppRatingHelper {
    
    // Draw a star mark with rating
    static func draw(with rating:Float, starImages:[UIImageView]) {
        /**
            1. 채운 별 아이콘을 5개 준비합니다.
            2. 평점을 몫과 나머지로 분리하여
            3. 몫 만큼 별은 보여주고 나머지는 비율만큼 마스크를 씌워 보여줍니다.         
        */
        let quotient = Int(rating)
        let remainder = rating - Float(quotient)
        for (index, imageView) in starImages.enumerated() {
            if quotient > index {
                imageView.alpha = 1
                imageView.unmask()
            } else if quotient == index {
                imageView.alpha = 1
                let fullWidth = Float(imageView.frame.size.width)
                let maskWidth = CGFloat(fullWidth * remainder)
                let maskHeight: CGFloat = imageView.frame.size.height
                imageView.mask(with: CGRect(x: 0, y: 0, width: maskWidth, height: maskHeight))
            } else {
                imageView.alpha = 0
                imageView.unmask()
            }
        }
    }
}
