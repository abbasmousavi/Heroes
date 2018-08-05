//
//  FavoritesStore.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/3/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation

protocol Store {
    func save(_ item: Hero)
    func remove(_ item: Hero)
    func isInStore(_ item: Hero) -> Bool
}

class FileStore: Store {
    
    let storeFilename = "Store"

    func URLForFileInDocumentsDirectory(_ filename: String) throws -> URL  {

        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectory.appendingPathComponent(filename)
    }
    
    var store = [Int: Hero]()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveToDisk), name: .UIApplicationWillTerminate, object: nil)
        do {
            let fileURL = try URLForFileInDocumentsDirectory(storeFilename)
            let jsonData = try Data(contentsOf: fileURL)
            store = try JSONDecoder().decode([Int: Hero].self, from: jsonData)
        } catch {
            print(error)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillTerminate, object: nil)
    }
    
    func save(_ item: Hero) {
        store[item.id] = item
        //saveToDisk()
    }
    
    func remove(_ item: Hero) {
        store.removeValue(forKey: item.id)
    }
    
    func isInStore(_ item: Hero) -> Bool {
        return store[item.id] != nil
    }
    
    @objc func saveToDisk() {

        do {
            let jsonData = try JSONEncoder().encode(store)
            let fileURL = try URLForFileInDocumentsDirectory(storeFilename)
            try jsonData.write(to: fileURL)
            
        } catch {
            print(error)
        }
    }
}
