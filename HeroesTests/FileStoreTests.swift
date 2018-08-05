//
//  FileStoreTests.swift
//  HeroesTests
//
//  Created by Abbas Mousavi on 8/5/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

@testable import Heroes
import XCTest

class FileStoreTests: XCTestCase {
    var heros = TestUtilities.LoadTestHeros()
    var store = FileStore("TestStore")

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        store.removeFromDisk()
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
        let newInstanceOfStore1 = FileStore("TestStore")
        XCTAssert(newInstanceOfStore1.isInStore(heros[0]))

        store.remove(heros[0])
        store.saveToDisk()
        let newInstanceOfStore2 = FileStore("TestStore")
        XCTAssertFalse(newInstanceOfStore2.isInStore(heros[0]))
    }

    func testWritePerformance() {
        _ = heros.map {
            store.save($0)
        }
        measure {
            store.saveToDisk()
        }
    }

    func testReadPerformance() {
        _ = heros.map {
            store.save($0)
        }
        store.saveToDisk()
        measure {
            _ = FileStore("TestStore")
        }
    }
}
