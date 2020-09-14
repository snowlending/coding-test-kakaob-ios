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
    var primaryGenre: String
    var genres: [String]?
    var genre: String {
        guard let genre = genres?[0], genres != nil else { return primaryGenre }
        return genre
    }
    var icon: String
    var rating: Float
    var roundedRating: Float {
        return (rating*10).rounded()/10
    }
    var nRatingCount: Int
    var ratingCount: String {
        return nRatingCount.withCommas()
    }
    var advisory: String
    var description: String
    var sellerName: String
    var sellerUrl: String?
    var screenshots: [String]
    var viewUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case primaryGenre = "primaryGenreName"
        case genres = "genres"
        case icon = "artworkUrl512"
        case rating = "averageUserRating"
        case nRatingCount = "userRatingCount"
        case advisory = "contentAdvisoryRating"
        case description = "description"
        case sellerName = "sellerName"
        case sellerUrl = "sellerUrl"
        case screenshots = "screenshotUrls"
        case viewUrl = "trackViewUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryGenre = try container.decode(String.self, forKey: .primaryGenre)
        self.genres = try container.decodeIfPresent([String].self, forKey: .genres)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.rating = try container.decode(Float.self, forKey: .rating)
        self.nRatingCount = try container.decode(Int.self, forKey: .nRatingCount)
        self.advisory = try container.decode(String.self, forKey: .advisory)
        self.description = try container.decode(String.self, forKey: .description)
        self.sellerName = try container.decode(String.self, forKey: .sellerName)
        self.sellerUrl = try container.decodeIfPresent(String.self, forKey: .sellerUrl)
        self.screenshots = try container.decode([String].self, forKey: .screenshots)
        self.viewUrl = try container.decode(String.self, forKey: .viewUrl)
    }
}
