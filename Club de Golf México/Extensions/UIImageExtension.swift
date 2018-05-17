//
//  UIImageExtension.swift
//
//  Created by admin on 1/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let placeHolder = UIImage(named: "placeholder")
    
    func resize(with newSize: CGSize)->UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return newImage

    }
    
    func resize(withWidth width: CGFloat) -> UIImage? {
        
        let ratio = width / self.size.width
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return newImage

    }
    func resize(withHeight height: CGFloat) -> UIImage? {
        
        let ratio = height / self.size.height
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage

    }
    
    func addedYoutubeButton() -> UIImage? {
        
        let newSize = CGSize(width: size.width, height: size.height)
        
        let youtubeSize = CGSize(width: 70, height: 50)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let youtubeImage = UIImage(named: "icono_youtube_play")?.resize(with: youtubeSize)
        
        youtubeImage?.draw(in: CGRect(x: newSize.width/2-youtubeSize.width/2, y: newSize.height/2-youtubeSize.height/2, width: youtubeSize.width, height: youtubeSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}

