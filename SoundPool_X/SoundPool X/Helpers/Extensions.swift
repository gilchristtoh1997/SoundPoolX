//
//  Extensions.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 12/24/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        //self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                if let currImage = UIImage(data: data!) {
                    imageCache.setObject(currImage, forKey: urlString as AnyObject)
                    self.image = currImage
                }
            })
        }).resume()
    }
}
