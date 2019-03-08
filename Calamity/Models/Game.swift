//
//  Game.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

typealias GameCallback = (_ success: Bool, _ error: Error?) -> Void
typealias ProgressCallback = (_ progress: CGFloat) -> Void

class Game: NSObject {
    static let instance = Game()
    
    var gameConstants: GameConstant? = nil
    var player: Player = Player()
    var dangers: [Danger] = []
    var events: [Event] = []
    var endings: [Ending] = []
    var libraryItems: [LibraryItem] = []
    
    var shuffledLibraryItems: [LibraryItem] {
        let shuffledElements = self.libraryItems.filter { (item) -> Bool in
            return item.day == self.daysCount
        }.shuffled()
        
        return shuffledElements
    }
    
    var liveDangers: [Danger]  {
        return self.dangers.filter({ (danger) -> Bool in
            return danger.removed == false
        })
    }
    
    var usedDangers: [Danger] {
        return self.dangers.filter({ (danger) -> Bool in
            return danger.removed == true
        })
    }
    
    var firedDangers: [Danger] {
        return self.dangers.filter({ (danger) -> Bool in
            return (danger.removed == false && danger.timeToAppear <= self.daysCount && danger.inProgress == false)
        })
    }
    
    var dangersToApply: [Danger] {
        return self.dangers.filter({ (danger) -> Bool in
            return (danger.removed == false && danger.timeToAppear <= self.daysCount && danger.affectedCity == nil)
        })
    }
    
    var cities: [City] = []
    
    var freeCities: [City] {
        return self.cities.filter({ (city) -> Bool in
            return (city.currentDanger == nil && city.currPeopleCount > 0)
        })
    }
    
    var currDayEvent: Event? {
        var currEvents: [Event] = []
        
        for event in events {
            guard event.days.contains(daysCount) else { continue }
            
            let manaSuitable = event.ifMana == UndefValue || event.ifMana == player.mana
            let peopleSuitable = event.ifPeopleRep == UndefValue || event.ifPeopleRep == player.peopleRep
            let kingSuitable = event.ifKingRep == UndefValue || event.ifKingRep == player.kingRep
            let corruptSuitable = event.ifCorrupt == UndefValue || event.ifCorrupt == player.corrupt
            
            if manaSuitable, peopleSuitable, kingSuitable, corruptSuitable {
                currEvents.append(event)
            }
        }
        
        return currEvents.randomElement()
    }
    
    var daysCount: Int = 1
    
    var leftTimeHours: Int {
        return self.gameConstants?.days_count?.constValue ?? self.daysCount - self.daysCount
    }
    
    private var loadedSheet: Sheet = .none
    private var sheets: [GoogleTable] = []
    
    private func reinitGame() {
        cities = []
        dangers = []
        daysCount = 1
        loadedSheet = .none
        
        sheets = [
            GoogleTable(table: .constants, url: ContentUrl.constantsSheetUrl),
            GoogleTable(table: .cities, url: ContentUrl.citiesSheetUrl),
            GoogleTable(table: .endings, url: ContentUrl.endingsSheetUrl),
            GoogleTable(table: .disasters, url: ContentUrl.disasterSheetUrl),
            GoogleTable(table: .replies, url: ContentUrl.repliesSheetUrl),
            GoogleTable(table: .archimags, url: ContentUrl.archimagsSheetUrl),
            GoogleTable(table: .library, url: ContentUrl.librarySheetUrl),
            GoogleTable(table: .events, url: ContentUrl.eventsSheetUrl),
            GoogleTable(table: .eventReplies, url: ContentUrl.eventRepliesSheetUrl),
        ]
        
        player.name = "Вася"
    }
    
    func updateGame(progress: ProgressCallback?, completion: GameCallback?) {
        loadSheet(sheetIndex: 0, progress: progress, completion: completion)
    }
    
    func loadGameOffline(progress: ProgressCallback?, completion: GameCallback?) {
        //    https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md
    }
    
    func loadSheet(sheetIndex: Int, progress: ProgressCallback?, completion: GameCallback?) {
        //    https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md
    }
    
    func parseGame(withUpdate: Bool, progress: ProgressCallback?, completion: GameCallback?) {
        reinitGame()
        
        if withUpdate {
            updateGame(progress: progress, completion: completion)
        } else {
            loadGameOffline(progress: progress, completion: completion)
        }
    }
    
    func checkState() {
        NotificationCenter.default.post(name: GameNotificationName.update.notificationName(), object: nil)
    }
}
