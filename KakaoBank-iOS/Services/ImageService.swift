//
//  ImageService.swift
//  KakaoBank-iOS
//
//  Created by James on 2020/09/13.
//  Copyright © 2020 Youngjin Cheon. All rights reserved.
//

import UIKit

class ImageService {
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Singleton
    static let shared: ImageService = {
        let instance = ImageService()
        return instance
    }()
    
    // Image download
    func downloadImage(withURLString urlString:String, completion: @escaping (_ image:UIImage?)->()) {
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                self.cache.setObject(downloadedImage!, forKey: urlString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        
        dataTask.resume()
    }
    
    // Get image from cache or remote
    func getImage(withURLString urlString:String, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: urlString as NSString) {
            completion(image)
        } else {
            downloadImage(withURLString: urlString, completion: completion)
        }
    }
}
