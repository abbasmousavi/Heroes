//
//  Utilities.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit
import ImageIO
import Foundation

let imageCache = NSCache<NSString, AnyObject>()
let marvelRedColor = UIColor(red:0.92, green:0.11, blue:0.13, alpha:1.00)

class NetworkImageView: UIImageView {
    var downloadTask: URLSessionDataTask?

    func setURL(url: URL) {

        downloadTask?.cancel()
        downloadTask = nil

        if let object = imageCache.object(forKey: url.absoluteString as NSString),
               object.isKind(of: UIImage.self) {

            self.image = object as? UIImage
        } else {


            self.image = UIImage(named: "loading")
            var image: CGImage?
            var imageSource: CGImageSource?
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)

            downloadTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let imageData = data {

                    let options: [String: Any] = [kCGImageSourceShouldCache as String: kCFBooleanTrue,
                        kCGImageSourceShouldAllowFloat as String: kCFBooleanTrue]



                    imageSource = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary)
                    image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)

                    let uiimage = UIImage(cgImage: image!)
                    imageCache.setObject(uiimage, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async { // 2
                        self.image = uiimage

                        //self.superview?.setNeedsLayout()
                    }

                } }

            downloadTask?.resume()
        }
    }
}

extension UIViewController {

    func addChild(_ viewController: UIViewController, in container: UIView) {

        addChild(viewController)
        container.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        viewController.didMove(toParent: self)
    }
}

extension String {
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
}
