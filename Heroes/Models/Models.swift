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
    let items: [Storie]
    let returned: Int
}

struct Storie: Codable {
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
    let type: String
    let url: String
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
}

extension Hero {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Hero.self, from: data) else { return nil }
        self = me
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
}

extension Comic {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Comic.self, from: data) else { return nil }
        self = me
    }
}

extension Stories {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Stories.self, from: data) else { return nil }
        self = me
    }
}

extension Storie {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Storie.self, from: data) else { return nil }
        self = me
    }
}

extension Thumbnail {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Thumbnail.self, from: data) else { return nil }
        self = me
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
}

