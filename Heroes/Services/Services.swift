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
    
    func request<T> (uri: String, parameters:[String:String] = [:], limit:Int = 20, offset:Int = 0, completion: @escaping ((APIResponse<T>) -> Void)) {
        
        let ts = Int(Date().timeIntervalSince1970)
        let hashableString = "\(ts)" + "925b08d6c60037b1d07a1123b0a80873d5f0da79" + "608dd9c32bcf28c626313e295070623c"
        let hash = hashableString.md5()

        var url = URLComponents(string: uri)!
        url.queryItems = parameters.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        url.queryItems?.append(URLQueryItem(name: "ts", value: "\(ts)"))
        url.queryItems?.append(URLQueryItem(name: "apikey", value: "608dd9c32bcf28c626313e295070623c"))
        url.queryItems?.append(URLQueryItem(name: "hash", value: hash!))
        url.queryItems?.append(URLQueryItem(name: "limit", value: "\(limit)"))
        url.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
        

        let request = URLRequest(url: url.url!)

        let task = session.dataTask(with: request) { (data, response, error) in
           let model = APIResponse<T>(data: data!)
                       // print(model)
            DispatchQueue.main.async { // 2
                completion(model!)
            }
            

            
        }
        
        task.resume()
    }

}
