//
//  Result.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/4/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation

enum Result<T: Codable> {
    case success(APIResponse<T>)
    case failure(Error)
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var value: APIResponse<T>? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
