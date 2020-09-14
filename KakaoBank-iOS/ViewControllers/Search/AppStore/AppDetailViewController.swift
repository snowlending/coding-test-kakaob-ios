//
//  AppDetailViewController.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/14.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit
import Alertift

class AppDetailViewController: UIViewController {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var svStarFill: UIStackView!
    var ivStarFills: [UIImageView] {
        return svStarFill.arrangedSubviews as! [UIImageView]
    }
    @IBOutlet weak var lbRatingCount: UILabel!
    @IBOutlet weak var lbAdvisory: UILabel!
    @IBOutlet weak var ivScreenshot1: UIImageView!
    @IBOutlet weak var ivScreenshot2: UIImageView!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbSellerName: UILabel!
    @IBOutlet weak var viewSeller: UIView!
    var app: App!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Shadow hidden
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        ImageService.shared.getImage(withURLString: app.icon) { image in
            self.ivIcon.image = image
        }
        lbName.text = app.name
        lbGenre.text = app.genre
        btnShare.imageView?.tintColor(with: ColorCompatibility.systemBlue)
        lbRating.text = "\(app.roundedRating)"
        AppRatingHelper.draw(with: app.rating, starImages: ivStarFills)
        lbRatingCount.text = "\(app.ratingCount)개의 평가"
        lbAdvisory.text = app.advisory
        ImageService.shared.getImage(withURLString: app.screenshots[0]) { image in
            self.ivScreenshot1.image = image
        }
        ImageService.shared.getImage(withURLString: app.screenshots[1]) { image in
            self.ivScreenshot2.image = image
        }
        lbDescription.text = app.description
        lbSellerName.text = app.sellerName
        viewSeller.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSeller(_:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        UIView.setAnimationsEnabled(false)
        crossDissolve()
    }
    
    @IBAction func didTapDownload(_ sender: Any) {
        Alertift.alert(title: "다운로드", message: "\(app.name)")
        .action(.default("확인"))
        .show()
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        guard let url = URL(string: app.viewUrl) else { return }
        let shareText = app.name
        ImageService.shared.getImage(withURLString: app.icon) { image in
            let shareContent: [Any] = [shareText, url, image!]
            let activityController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc func didTapSeller(_ sender: UITapGestureRecognizer? = nil) {
        if let url = URL(string: app.sellerUrl ?? String()) {
            UIApplication.shared.open(url)
        }
    }
}
