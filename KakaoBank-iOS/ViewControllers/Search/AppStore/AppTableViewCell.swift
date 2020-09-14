//
//  AppTableViewCell.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/11.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbRatingCount: UILabel!
    @IBOutlet weak var svStarFill: UIStackView!
    var ivStarFills: [UIImageView] {
        return svStarFill.arrangedSubviews as! [UIImageView]
    }
    @IBOutlet weak var svScreenshot: UIStackView!
    var ivScreenshots: [UIImageView] {
        return svScreenshot.arrangedSubviews as! [UIImageView]
    }
    @IBOutlet weak var btnGet: UIButton!
    
    var dataTasks = [String:URLSessionDataTask?]()
    var downloadActionBlock: (() -> Void)? = nil
    
    // UI setting with data
    func set(app: App) {
        lbName.text = app.name
        lbGenre.text = app.genre
        AppRatingHelper.draw(with: app.rating, starImages: ivStarFills)
        lbRatingCount.text = app.ratingCount
        ImageService.shared.getImage(withURLString: app.icon) { image in
            self.ivIcon.image = image
        }
        for (index, screenshot) in app.screenshots.enumerated() {
            ImageService.shared.getImage(withURLString: screenshot) { image in
                self.ivScreenshots[safe: index]?.image = image
            }
        }
    }
    
    @IBAction func didTapDownload(_ sender: Any) {
        downloadActionBlock?()
    }
}
