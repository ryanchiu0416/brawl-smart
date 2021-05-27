//
//  Brawler.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/13/21.
//

import Foundation

class Brawler: CustomDebugStringConvertible, Codable {
    var debugDescription: String {
        return "Brawler(\(self.name), \(self.class), \(self.rarity), \(self.description))"
    }
    var id: Int
    var name: String
    var imageUrl: String
    var `class`: ClassKind
    var rarity: Rarity
    var description: String
    var starPowers: [StarPower]
    var gadgets: [Gadget]
    var imageData: NSData? = nil
    var isFavorite: Bool = false
    
    init(hasId id: Int, named name: String, hasImageLink imageUrl: String, isOfClass `class`: ClassKind, isOfRarity rarity: Rarity, description: String, starPowers: [StarPower], gadgets: [Gadget]) {
        self.name = name
        self.`class` = `class`
        self.rarity = rarity
        self.description = description
        self.id = id
        self.gadgets = gadgets
        self.starPowers = starPowers
        self.imageUrl = imageUrl

    }
    
    
    private enum CodingKeys: String, CodingKey {
        case id, name, imageUrl, `class`, rarity, description, starPowers, gadgets
    }
}

struct StarPower: Codable {
    var name: String
    var description: String
    var imageUrl: String
}

struct Gadget: Codable {
    var name: String
    var description: String
    var imageUrl: String
}

struct Rarity: Codable {
    var name: String
    var color: String
}

struct ClassKind: Codable {
    var id: Int
    var name: String
}


struct BrawlerResult: Codable {
    let list: [Brawler]
}


