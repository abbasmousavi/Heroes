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
    
    func request<T> (uri: String, limit:Int = 20, offset:Int = 0, completion: @escaping ((APIResponse<T>) -> Void)) {
        
        let ts = Int(Date().timeIntervalSince1970)
        let hashableString = "\(ts)" + "925b08d6c60037b1d07a1123b0a80873d5f0da79" + "608dd9c32bcf28c626313e295070623c"
        let hash = hashableString.md5()
        let authString = "ts=\(ts)&apikey=608dd9c32bcf28c626313e295070623c&hash=" + hash! + "&limit=\(limit)&offset=\(offset)"
        
        let url = URL(string:uri + "?" + authString)
        
        let request = URLRequest(url: url!)

        let task = session.dataTask(with: request) { (data, response, error) in
           let model = APIResponse<T>(data: data!)
                        print(model)
            DispatchQueue.main.async { // 2
                completion(model!)
            }
            

            
        }
        
        task.resume()
    }

}
