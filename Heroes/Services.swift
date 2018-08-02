//
//  Services.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit
import Foundation

class Services {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func request (completion: @escaping ((Models) -> Void)) {
        
        let ts = Int(Date().timeIntervalSince1970)
        let hashableString = "\(ts)" + "925b08d6c60037b1d07a1123b0a80873d5f0da79" + "608dd9c32bcf28c626313e295070623c"
        
        let hash = hashableString.md5()
        
        let url = URL(string:"https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=608dd9c32bcf28c626313e295070623c&hash=" + hash!)
        
        let request = URLRequest(url: url!)

        let task = session.dataTask(with: request) { (data, response, error) in
           let model = Models(data: data!)
                        print(model)
            DispatchQueue.main.async { // 2
                completion(model!)
            }
            

            
        }
        
        task.resume()
    }

}
