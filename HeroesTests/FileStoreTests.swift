//
//  FileStoreTests.swift
//  HeroesTests
//
//  Created by Abbas Mousavi on 8/5/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import XCTest
@testable import  Heroes

class FileStoreTests: XCTestCase {
    
    var heros = [Hero]()
    var store = FileStore("TestStore")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        do {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "TestData", withExtension: "json")
            let jsonData = try Data(contentsOf: fileURL!)
            let response = try JSONDecoder().decode(APIResponse<Hero>.self, from: jsonData)
            heros = response.data.results
        
        } catch {
            print(error)
        }
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWritingAndReadingFormStore() {
        
        store.save(heros[0])
        XCTAssert(store.isInStore(heros[0]))
        store.remove(heros[0])
        XCTAssertFalse(store.isInStore(heros[0]))

    }
    
    func testLoadingStoreFromDisk() {
        store.save(heros[0])
        store.saveToDisk()
        let newInstanceOfStore = FileStore("TestStore")
        XCTAssert(newInstanceOfStore.isInStore(heros[0]))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
