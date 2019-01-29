//
//  Constants.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/21/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

let isCompact: Bool = UIApplication.shared.keyWindow!.rootViewController!.view!.traitCollection.horizontalSizeClass == .compact

let UndefValue = -1

struct ContentUrl {
    static let disasterSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/od6")
    static let repliesSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/o1e9lp4")
    static let citiesSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ommsews")
    static let endingsSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ocghpen")
    static let archimagsSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oagl4ao")
    static let librarySheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/okm6ig0")
    static let eventsSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oe9dn37")
    static let eventRepliesSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/odwe38y")
    static let constantsSheetUrl = URL(string: "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oj5lh0f")
}

struct Variable {
    static let minValue = 0
    static let maxValue = 100
}

struct NotificationName {
    static let clearDanger = "clearDanger"
    static let clearEvent = "clearEvent"
}

struct Sheet: OptionSet {
    let rawValue: Int
    
    static let cities = Sheet(rawValue: 1 << 0)
    static let disasters = Sheet(rawValue: 1 << 1)
    static let replies = Sheet(rawValue: 1 << 2)
    static let endings = Sheet(rawValue: 1 << 3)
    static let archimags = Sheet(rawValue: 1 << 4)
    static let library = Sheet(rawValue: 1 << 5)
    static let events = Sheet(rawValue: 1 << 6)
    static let eventReplies = Sheet(rawValue: 1 << 7)
    static let constants = Sheet(rawValue: 1 << 8)
    
    static let all: Sheet = [.cities, .disasters, .replies, .endings, .archimags, .library, .events, .eventReplies, .constants]
}

enum GameSound: String {
    case battleLoosing = "battle_loosing.wav"
    case battleWin = "battle_win.wav"
    case timeTicking = "time_ticking.wav"
    case casting = "casting.m4a"
    case dangerHappen = "danger_happen.wav"
}

enum AbilityType: Int {
    case telekinesis = 1
    case appeal
    case hypnosis
    case chaos
    case nobody
}

enum DangerType: Int {
    case disaster = 1
    case monsters
    case plague
    case curse
}

enum GameEnding: Int {
    case won = 1
    case defeat = 3
}

enum ParseKey: String {
    case id = "id"
    case disasterId = "id_disaster"
    case name = "name"
    case type = "type"
    case day = "day"
    case description = "description"
    case people = "people"
    case replyId = "id_reply"
    case text = "text"
    case cost = "cost"
    case time = "time"
    case result = "result"
}
