//
//  Models.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation

protocol Listable {
    var title:String? {get}
    var thumbnail: Thumbnail? {get}
}

struct APIResponse<T:Codable>: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String
    let data: ResponseData<T>
}

struct ResponseData<T:Codable>: Codable {
    let offset, limit, total, count: Int
    let results: [T]
}

struct Hero: Codable {
    let id: Int
    let name, description, modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLSpecifier]
}

struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [Comic]
    let returned: Int
}

struct Comic: Codable, Listable {
    let resourceURI: String
    let name: String?
    var title: String?
    var thumbnail: Thumbnail?
}

struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

struct StoriesItem: Codable {
    let resourceURI, name: String
    let type: String
}

struct Thumbnail: Codable {
    let path: String?
    let pathExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case pathExtension = "extension"
    }
}

struct URLSpecifier: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}

// MARK: Convenience initializers

extension APIResponse {
    
    init(data: Data) throws {
        let me = try JSONDecoder().decode(APIResponse.self, from: data)
        self = me
    }
}

extension ResponseData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ResponseData.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Hero {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Hero.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Hero: Equatable {
    static func == (lhs: Hero, rhs: Hero) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    
}

extension Comics {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Comics.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Comic {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Comic.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Stories {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Stories.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension StoriesItem {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(StoriesItem.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }



    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Thumbnail {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Thumbnail.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }


    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    var thumbnailURL:URL? {
    
        guard let path = self.path, let extention = pathExtension else {return nil}
        return URL(string: path + "." + extention)
    }
}

extension URLSpecifier {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(URLSpecifier.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

