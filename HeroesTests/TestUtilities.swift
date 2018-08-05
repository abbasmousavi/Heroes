//
//  Utilities.swift
//  HeroesTests
//
//  Created by Abbas Mousavi on 8/5/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation
@testable import Heroes

class TestUtilities {
    
    class func LoadTestHeros() -> [Hero] {
        do {
            let testBundle = Bundle(for: TestUtilities.self)
            let fileURL = testBundle.url(forResource: "TestData", withExtension: "json")
            let jsonData = try Data(contentsOf: fileURL!)
            let response = try JSONDecoder().decode(APIResponse<Hero>.self, from: jsonData)
            return response.data.results
        } catch {
            assert(true, "Can not load test data.")
            return [Hero]()
        }
    }
}
