//
//  SearchHistoryHelper.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/11.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import Foundation

class SearchHistoryService {
    
    private let KEY = "SavedStringArray"
    private var history: [String]!
    
    // Singleton
    static let shared: SearchHistoryService = {
        let instance = SearchHistoryService()
        instance.history = instance.all()
        return instance
    }()
    
    // Return all search history
    func all() -> [String] {
        guard history == nil else {
            return history
        }
        
        let defaults = UserDefaults.standard
        history = defaults.stringArray(forKey: KEY) ?? [String]()
        return history
    }
    
    // Add search
    func add(term: String) {
        let defaults = UserDefaults.standard
        var data = defaults.stringArray(forKey: KEY) ?? [String]()
        if let hasTerm = data.firstIndex(of: term) {
            data.remove(at: hasTerm)
        }
        data.insert(term, at: 0)
        defaults.set(data, forKey: KEY)
        history = data
    }
    
    // Reset history
    func reset() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: KEY)
        history = [String]()
    }
    
}
