//
//  App.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/11.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import Foundation

struct AppResponse: Decodable {
    var resultCount: Int
    var results: [App]
}

struct App: Decodable {
    var name: String
    var genre: String
    var icon: String
    var screenshots: [String]
    
    var media: [String] {
        var images = screenshots
        images.insert(icon, at: 0)
        return images
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case genre = "primaryGenreName"
        case icon = "artworkUrl512"
        case screenshots = "screenshotUrls"
    }
}
