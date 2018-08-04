//
//  FavoritesStore.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/3/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation

protocol Store {
    associatedtype T:Equatable
    func save(item:T)
    func remove(item:T)
    func isInStore(item:T) -> Bool
}

class FileStore: Store {
    
    var store = [Int:Hero]()
    
    func save(item:Hero)  {
        store[item.id] = item
    }
    
    func remove(item:Hero)  {
        store.removeValue(forKey: item.id)
    }
    
    func isInStore(item:Hero) -> Bool {
        return store[item.id] != nil
    }
}
