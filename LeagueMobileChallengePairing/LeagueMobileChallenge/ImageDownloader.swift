//
//  ImageDownloader.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/23/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    
    // MARK: Private init
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }
    
    
    // A serial queue to be able to write the non-thread-safe dictionary
    let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    
    
    func downloadImage(with imageUrlString: String?,
                       index: Int,
                       completionHandler: @escaping (UIImage?, Int) -> Void,
                       placeholderImage: UIImage?) {
        
        guard let imageUrlString = imageUrlString else {
            completionHandler(placeholderImage, index)
            return
        }
        
        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completionHandler(image, index)
        } else {
            guard let url = URL(string: imageUrlString) else {
                completionHandler(placeholderImage, index)
                return
            }
            
            if let _ = getDataTaskFrom(urlString: imageUrlString) {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeholderImage, index)
                    }
                    return
                }
                
                let image = UIImage(data: data)
                
                // Store the downloaded image in cache
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[imageUrlString] = image
                }
                
                // Clear out the finished task from download tasks container
                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrlString)
                }
                
                // Always execute completion handler explicitly on main thread
                DispatchQueue.main.async {
                    completionHandler(image, index)
                }
            }
            
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrlString] = task
            }
            
            task.resume()
        }
        
        
        func getCachedImageFrom(urlString: String) -> UIImage? {
            // Reading from the dictionary should happen in the thread-safe manner.
            serialQueueForImages.sync {
                return cachedImages[urlString]
            }
        }
        
        func getDataTaskFrom(urlString: String) -> URLSessionTask? {
            
            // Reading from the dictionary should happen in the thread-safe manner.
            serialQueueForDataTasks.sync {
                return imagesDownloadTasks[urlString]
            }
        }
    }
}
