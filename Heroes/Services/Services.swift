//
//  Services.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit
import Foundation

let publicKey = "608dd9c32bcf28c626313e295070623c"
let privateKey = "925b08d6c60037b1d07a1123b0a80873d5f0da79"

class Services {

    let session = URLSession(configuration: URLSessionConfiguration.default)
    let store: Store

    init (store: Store) {
        self.store = store
    }

    func request<T> (uri: String, parameters: [String: String] = [:], limit: Int = 20, offset: Int = 0, completion: @escaping ((Result<T>) -> Void)) {

        let ts = Int(Date().timeIntervalSince1970)
        let hashableString = "\(ts)" + privateKey + publicKey
        let hash = hashableString.md5()

        var url = URLComponents(string: uri)!
        url.queryItems = parameters.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        url.queryItems?.append(URLQueryItem(name: "ts", value: "\(ts)"))
        url.queryItems?.append(URLQueryItem(name: "apikey", value: publicKey))
        url.queryItems?.append(URLQueryItem(name: "hash", value: hash!))
        url.queryItems?.append(URLQueryItem(name: "limit", value: "\(limit)"))
        url.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))

        let request = URLRequest(url: url.url!)

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(Result.failure(error!))
                }
                return
            }
            guard 200 ... 299 ~= (response as! HTTPURLResponse).statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                }
                return
            }

            do {
                let response = try APIResponse<T>(data: data!)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    func loadHeroesList(query: String?, offset: Int, completion: @escaping ((Result<Hero>) -> Void)) {
        
        let parameters: [String: String] = query == nil ? [:] : ["nameStartsWith": query!]
        request(uri: "https://gateway.marvel.com/v1/public/characters", parameters: parameters, offset: offset, completion: completion)
    }
}
