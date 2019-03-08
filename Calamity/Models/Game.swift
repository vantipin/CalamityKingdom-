//
//  Game.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Mantle

typealias GameCallback = (_ success: Bool, _ error: Error?) -> Void
typealias ProgressCallback = (_ progress: CGFloat) -> Void

class Game: NSObject {
    static let instance = Game()
    
    var gameConstants: GameConstant? = nil
    let player: Player = Player()
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
    
    func configure(objects: [GDBModel], sheet: Sheet) {
        
    }
    
    func filePath(sheet: Sheet) -> String? {
        let fileName = sheet.sheetName
        let fileExtension = "json"
        
        let bookSettingsPath = "\(fileName).\(fileExtension)"
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let filePath = docDir?.appending(bookSettingsPath)
        return filePath
    }
    
    func loadGameOffline(progress: ProgressCallback?, completion: GameCallback?) {
        let type = "json"
        
        for (index, table) in sheets.enumerated() {
            let fileName = table.sheet.sheetName
            
            guard let filePath = self.filePath(sheet: table.sheet) else {
                completion?(false, GameError.parseOfflineError)
                return
            }
            
            if !FileManager.default.fileExists(atPath: filePath) {
                if let bundleSettingsPath = Bundle.main.path(forResource: fileName, ofType: type), FileManager.default.fileExists(atPath: bundleSettingsPath) {
                    
                    do {
                        try FileManager.default.copyItem(atPath: bundleSettingsPath, toPath: filePath)
                    } catch {
                        completion?(false, GameError.parseOfflineError)
                        return
                    }
                }
            }
            
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
                
                guard jsonData.count > 0 else { continue }

                let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<[AnyHashable : Any]> ?? []
                
                var objects: [GDBModel] = []
                let modelClass: AnyClass = table.sheet.modelClass
                
                for obj in jsonArray {
                    let model = try MTLJSONAdapter.model(of: modelClass, fromJSONDictionary: obj)
                    objects.append(model as! GDBModel)
                }
                
                self.configure(objects: objects, sheet: table.sheet)
            } catch(let error) {
                print("error = \(error)")
                completion?(false, GameError.parseOfflineError)
                return
            }
            
            progress?(CGFloat(index + 1) / CGFloat(sheets.count))
        }
        
        player.initialize()
        completion?(true, nil)
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
