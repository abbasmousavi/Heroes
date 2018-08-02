//
//  Utilities.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit
import ImageIO

extension String {
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        //result.destroy()
        
        return String(format: hash as String)
    }
}


extension UIImageView {
    func setURL(url:URL) {
        
        //self.image = UIImage()
        var image: CGImage?
        var imageSource: CGImageSource?
//        var options: CFDictionary
//        var keys: CFString
//        var values: CFTypeRef
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           
            if let imageData = data {
            
            let options : [String: Any] = [kCGImageSourceShouldCache as String : kCFBooleanTrue,
                                         kCGImageSourceShouldAllowFloat as String : kCFBooleanTrue]
//            var result : CFTypeRef?
//            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            
            imageSource = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary)
        image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
            
            DispatchQueue.main.async { // 2
                self.image = UIImage(cgImage: image!)

                self.superview?.setNeedsLayout()
            }
            
            }}
        
        task.resume()
            

        
       
//        keys[0] = kCGImageSourceShouldCache
//        values[0] = (CFTypeRef)kCFBooleanTrue
//
//        keys[1] = kCGImageSourceShouldAllowFloat
//        values[1] = (CFTypeRef)kCFBooleanTrue
//
//        options =
//
//
//        // Set up options if you want them. The options here are for
//        // caching the image in a decoded form and for using floating-point
//        // values if the image format supports them.
//        myKeys[0] = kCGImageSourceShouldCache;
//        myValues[0] = (CFTypeRef)kCFBooleanTrue;
//        myKeys[1] = kCGImageSourceShouldAllowFloat;
//        myValues[1] = (CFTypeRef)kCFBooleanTrue;
//        // Create the dictionary
//        myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
//                                       (const void **) myValues, 2,
//                                       &kCFTypeDictionaryKeyCallBacks,
//                                       & kCFTypeDictionaryValueCallBacks);
        
   //     imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)
        //CFRelease(options)
        
        // Create an image source from the URL.
//        myImageSource = CGImageSourceCreateWithURL((CFURLRef)url, myOptions);
//        CFRelease(myOptions);
//        // Make sure the image source exists before continuing
//        if (myImageSource == NULL){
//            fprintf(stderr, "Image source is NULL.");
//            return  NULL;
//        }
        
  //      image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
//        // Create an image from the first item in the image source.
//        myImage = CGImageSourceCreateImageAtIndex(myImageSource,
//                                                  0,
//                                                  NULL);
        
        //CFRelease(imageSource)
        // Make sure the image exists before continuing
//        if (myImage == NULL){
//            fprintf(stderr, "Image not created from image source.");
//            return NULL;
//        }
    
    //    self.image = UIImage(cgImage: image!)
    
    
    
    }
}
