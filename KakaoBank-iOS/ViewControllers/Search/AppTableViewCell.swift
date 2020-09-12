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
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var ivStar: UIImageView!
    @IBOutlet weak var ivStarFill: UIImageView!
    @IBOutlet weak var lbRate: UILabel!
    @IBOutlet weak var svScreenShot: UIStackView!
    @IBOutlet weak var btnGet: UIButton!
}
