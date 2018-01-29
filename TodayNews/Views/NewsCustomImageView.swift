//
//  NewsCustomImageView.swift
//  TodayNews
//
//  Created by Ron Rith on 1/17/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  
    func downloadImageWith(urlString: String, completion: @escaping () -> ()) {
        // Remove image
        self.image = nil
        
        // Read image from cache
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion()
            return
            
        }
        // Run background process
        DispatchQueue.global(qos: .background).async {
            do {
                let url = URL(string: urlString)
                let imageData = try Data.init(contentsOf: url!)
                // Return to UI process
                DispatchQueue.main.sync {
                    let imageToCache = UIImage(data: imageData)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    completion()
                }
            } catch  {
                print("download image error")
            }
        }
    }
    
    func loadImageUsingUrlString(urlString: String) {
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.sync {
                
                let imageToCache = UIImage(data: data!)
                
                self.image = imageToCache
                
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
            
        }).resume()
    }
}

