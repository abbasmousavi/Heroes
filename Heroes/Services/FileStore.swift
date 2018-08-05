//
//  FavoritesStore.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/3/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation

protocol Store {
    
    func save(_ item:Hero)
    func remove(_ item:Hero)
    func isInStore(_ item:Hero) -> Bool
}

class FileStore: Store {
    
    var store = [Int:Hero]()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveToDisk), name: .UIApplicationWillTerminate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillTerminate, object: nil)
    }
    
    func save(_ item:Hero)  {
        store[item.id] = item
    }
    
    func remove(_ item:Hero)  {
        store.removeValue(forKey: item.id)
    }
    
    func isInStore(_ item:Hero) -> Bool {
        return store[item.id] != nil
    }
    
    @objc func saveToDisk() {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(store)
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("store")
            try jsonData.write(to: fileURL)
            
        } catch {
            print(error)
        }
    }
}
