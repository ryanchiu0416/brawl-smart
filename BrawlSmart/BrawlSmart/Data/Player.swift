//
//  Player.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/25/21.
//

import Foundation
class Player: CustomDebugStringConvertible, Codable {
    var debugDescription: String {
        return "Player(\(self.name), \(self.tag))"
    }
    var name: String = ""
    var tag: String = ""
    var icon: Icon? = nil
    var _3vs3Victories: Int = 0
    var trophies: Int = 0
    var expLevel: Int = 0
    var highestTrophies: Int = 0
    var soloVictories: Int = 0
    var duoVictories: Int = 0
    var nameColor: String = ""
    
    
    init(hasTag tag: String, hasName name: String, hasIcon icon: Icon, vict3v3 _3vs3Victories: Int, hasTrophies trophies: Int, ofExpLevel expLevel: Int, hasHighestTrophy highestTrophies: Int, soloVict soloVictories: Int, duoVict duoVictories: Int, ofNameColor nameColor: String) {
        self.expLevel = expLevel
        self.highestTrophies = highestTrophies
        self.name = name
        self.nameColor = nameColor
        self.tag = tag
        self.trophies = trophies
        self._3vs3Victories = _3vs3Victories
        self.duoVictories = duoVictories
        self.soloVictories = soloVictories
        self.icon = icon
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, tag, expLevel, highestTrophies, nameColor, trophies, icon, duoVictories, soloVictories
        case _3vs3Victories = "3vs3Victories"
    }
}

struct Icon: Codable {
    var id: Int
}
