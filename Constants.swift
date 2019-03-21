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
    static let disasterSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/od6"
    static let repliesSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/o1e9lp4"
    static let citiesSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ommsews"
    static let endingsSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ocghpen"
    static let archimagsSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oagl4ao"
    static let librarySheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/okm6ig0"
    static let eventsSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oe9dn37"
    static let eventRepliesSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/odwe38y"
    static let constantsSheetUrl = "https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oj5lh0f"
}

struct Variable {
    static let minValue = 0
    static let maxValue = 100
}

struct Sheet: OptionSet {
    let rawValue: Int
    
    static let none = Sheet(rawValue: 0)
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
    
    func parseStatus() -> String {
        switch self.rawValue {
        case Sheet.cities.rawValue:
            return "Парсим города"
        case Sheet.disasters.rawValue:
            return "Парсим опасности"
        case Sheet.replies.rawValue:
            return "Парсим результаты опасностей"
        case Sheet.endings.rawValue:
            return "Парсим концовки"
        case Sheet.archimags.rawValue:
            return "Парсим архимагов"
        case Sheet.library.rawValue:
            return "Парсим библиотеку"
        case Sheet.events.rawValue:
            return "Парсим события"
        case Sheet.eventReplies.rawValue:
            return "Парсим результаты событий"
        case Sheet.constants.rawValue:
            return "Парсим константы"
        default:
            return ""
        }
    }
    
    var sheetName: String {
        switch self.rawValue {
        case Sheet.cities.rawValue:
            return "Cities"
        case Sheet.disasters.rawValue:
            return "Disasters"
        case Sheet.replies.rawValue:
            return "Replies"
        case Sheet.endings.rawValue:
            return "Endings"
        case Sheet.archimags.rawValue:
            return "Archimags"
        case Sheet.library.rawValue:
            return "Library"
        case Sheet.events.rawValue:
            return "Events"
        case Sheet.eventReplies.rawValue:
            return "EventReplies"
        case Sheet.constants.rawValue:
            return "Constants"
        default:
            return ""
        }
    }
    
    var modelClass: AnyClass {
        switch self.rawValue {
        case Sheet.cities.rawValue:
            return City.self
        case Sheet.disasters.rawValue:
            return Danger.self
        case Sheet.replies.rawValue:
            return Ability.self
        case Sheet.endings.rawValue:
            return Ending.self
        case Sheet.archimags.rawValue:
            return Archimage.self
        case Sheet.library.rawValue:
            return LibraryItem.self
        case Sheet.events.rawValue:
            return Event.self
        case Sheet.eventReplies.rawValue:
            return EventAbility.self
        case Sheet.constants.rawValue:
            return Constant.self
        default:
            return GoogleBaseModel.self
        }
    }
    
    func filePath() -> String? {
        let fileName = self.sheetName
        let fileExtension = "json"
        
        let bookSettingsPath = "/\(fileName).\(fileExtension)"
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let filePath = docDir?.appending(bookSettingsPath)
        return filePath
    }
}

enum GameNotificationName: String {
    case clearDanger = "clearDanger"
    case clearEvent = "clearEvent"
    case updateUI = "updateUI"
    case clearUI = "clearUI"
    case timerTick = "timerTick"

    func notificationName() -> NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

enum GameSound: String {
    case battleLoosing = "battle_loosing"
    case battleWin = "battle_win"
    case timeTicking = "time_ticking"
    case casting = "casting"
    case dangerHappen = "danger_happen"
    
    func ext() -> String {
        switch self {
        case .battleLoosing:
            return "wav"
        case .battleWin:
            return "wav"
        case .timeTicking:
            return "wav"
        case .casting:
            return "m4a"
        case .dangerHappen:
            return "wav"
        }
    }
}

enum AbilityType: Int {
    case telekinesis = 1
    case appeal
    case hypnosis
    case chaos
    case nobody
}

enum CityType: Int {
    case capital = 1
    case town2
    case town1
    case villageLumberers
    case villageVariors
    case villageFishermans
    
    func imageName() -> String {
        switch self {
        case .capital:
            return "CapitalCity"
        case .town2:
            return "Town2City"
        case .town1:
            return "Town1City"
        case .villageLumberers:
            return "VillageLumbererCity"
        case .villageVariors:
            return "VillageVariorsCity"
        case .villageFishermans:
            return "VillageFishermansCity"
        }
    }
}

enum DangerType: Int {
    case disaster = 1
    case monsters
    case plague
    case curse
    
    func name() -> String {
        switch self {
        case .disaster:
            return "Стихия"
        case .monsters:
            return "Чудовища"
        case .plague:
            return "Мор"
        case .curse:
            return "Проклятие"
        }
    }
    
    func iconImage() -> UIImage {
        var name = ""
        
        switch self {
        case .disaster:
            name = "danger_elements"
        case .monsters:
            name = "danger_monsters"
        case .plague:
            name = "danger_plages"
        case .curse:
            name = "danger_curse"
        }
        
        return UIImage(named: name) ?? UIImage()
    }
}

enum EventType: Int {
    case nothing = 0
    case king = 1
    case demon
    case mage
    case swords
    case torch
    
    func iconImage() -> UIImage {
        var name = ""
        
        switch self {
        case .king:
            name = "EventKingIcon"
        case .demon:
            name = "EventDemonIcon"
        case .mage:
            name = "EventMagIcon"
        case .swords:
            name = "EventSwordsIcon"
        case .torch:
            name = "EventTorchIcon"
        default:
            break
        }
        
        return UIImage(named: name) ?? UIImage()
    }
}

enum GameEnding: String {
    case won = "1"
    case defeat = "3"
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

enum GameError: Error {
    case unknownError
    case parseOfflineError
}
