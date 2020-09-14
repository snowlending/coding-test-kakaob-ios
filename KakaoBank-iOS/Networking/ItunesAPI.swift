//
//  API.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/12.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import Foundation

class ItunesAPI {
    
    static let shared = ItunesAPI(baseURL:  URL(string: "https://itunes.apple.com/")! )
    var baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // Search for app
    func searchApp(term: String, limit: Int = 200, _ completionHandler: @escaping (Int, Data?, Error?) -> Void) -> URLSessionDataTask? {
        let urlParameters: [String: String] = [
            "term":term,
            "country":"KR",
            "entity":"software",
            "lang":"ko_KR",
            "explicit":"NO",
            "limit":String(limit)
        ]
        return self.request(to: "search", method: "GET", urlParameters: urlParameters, completionHandler: { code, data, error in
            completionHandler(code, data, error)
        })
    }
    
    // Send request
    private func request(to endpoint: String, method: String = "GET", urlParameters: [String:String?]? = nil, completionHandler: @escaping (Int, Data?, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = url(with: endpoint, urlParameters: urlParameters) else { completionHandler(0, nil, nil); return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = method
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            completionHandler((response as? HTTPURLResponse)?.statusCode ?? 0, data, error)
        })
        task.resume()
        return task
    }
    
    // Return url
    private func url(with endpoint: String, urlParameters: [String: String?]? = nil) -> URL? {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.path += endpoint
        if let params = urlParameters {
            urlComponents.queryItems = params.map { (k, v) in
                return URLQueryItem(name: k, value: v)
            }
        }
        return urlComponents.url
    }
 
    
}
