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
    
    func save(_ item:Hero)  {
        store[item.id] = item
    }
    
    func remove(_ item:Hero)  {
        store.removeValue(forKey: item.id)
    }
    
    func isInStore(_ item:Hero) -> Bool {
        return store[item.id] != nil
    }
}
