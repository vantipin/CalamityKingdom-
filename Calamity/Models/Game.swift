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
    
    private func updateGame(progress: ProgressCallback?, completion: GameCallback?) {
        loadSheet(sheetIndex: 0, progress: progress, completion: completion)
    }
    
    func configure(objects: [GDBModel], sheet: Sheet) {
        switch sheet.rawValue {
        case Sheet.cities.rawValue:
            for cityObj in objects {
                guard let city = cityObj as? City else { continue }
                
                cities.append(city)
            }
        case Sheet.disasters.rawValue:
            for dangerObj in objects {
                guard let danger = dangerObj as? Danger else { continue }
                
                danger.result.peopleCountToDie = [danger.defaultDieCoef]
                danger.result.defaultDieCoef = danger.defaultDieCoef
                dangers.append(danger)
            }
        case Sheet.replies.rawValue:
            for abilityObj in objects {
                guard let ability = abilityObj as? Ability, let danger = self.dangers.filter({ (danger) -> Bool in
                    return danger.identifier == ability.dangerId
                }).first else { continue }
                
                danger.result.peopleCountToDie.append(ability.damage / CGFloat(100))
                danger.appendAbility(ability: ability)
            }
        case Sheet.endings.rawValue:
            if let endObjects = objects as? [Ending] {
                endings = endObjects
            }
        case Sheet.archimags.rawValue:
            break
        case Sheet.library.rawValue:
            if let libraryObjects = objects as? [LibraryItem] {
                libraryItems = libraryObjects
            }
        case Sheet.events.rawValue:
            if let eventObjects = objects as? [Event] {
                events = eventObjects
            }
        case Sheet.eventReplies.rawValue:
            for replyObj in objects {
                guard let ability = replyObj as? EventAbility, let event = self.events.filter({ (event) -> Bool in
                    return event.identifier == ability.eventId
                }).first else { continue }
                
                event.appendAbility(ability: ability)
            }
        case Sheet.constants.rawValue:
            let gc = GameConstant()
            
            for constObj in objects {
                guard let constant = constObj as? Constant else { continue }
                
                gc[keyPath: GameConstant.keyPath(fromId: constant.identifier)] = constant
            }
            
            gameConstants = gc
            
        default:
            break
        }
    }
    
    private func loadGameOffline(progress: ProgressCallback?, completion: GameCallback?) {
        let type = "json"
        
        for (index, table) in sheets.enumerated() {
            let fileName = table.sheet.sheetName
            
            guard let filePath = table.sheet.filePath() else {
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
    
    private func save(objects: [GoogleBaseModel], forSheet sheet: Sheet) {
        do {
            let jsons = try objects.compactMap {
                return try SmartJSONAdapter.jsonDictionary(fromModel: $0)
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsons, options: .prettyPrinted)
            
            guard let path = sheet.filePath() else {
                print("Save models sheet path error: \(sheet)")
                return
            }
            
//            print("Save models of \(objects.first.self?.classForCoder ?? GoogleBaseModel.self) for path \(path)")
            
            try jsonData.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print("Save models error!")
        }
    }
    
    func loadSheet(sheetIndex: Int, progress: ProgressCallback?, completion: GameCallback?) {
        guard sheetIndex < sheets.count else {
            print("Sheet index ERROR!")
            return
        }

        let table = sheets[sheetIndex]
        let loadingSheet = table.sheet
        
        let modelClass: AnyClass = loadingSheet.modelClass
        
        GoogleDocsServiceLayer.objects(worksheetKey: table.worksheetId, sheetId: table.sheetId, modelClass: modelClass) { [weak self] (objects, error) in
            guard let self = self, error == nil else {
                completion?(false, error)
                return
            }
            
            let filteredObject = objects?.filter({ (model) -> Bool in
                guard let model = model as? GoogleBaseModel else { return false }
                return model.identifier.count > 0
            })
            
            guard let googleModels = filteredObject as? [GoogleBaseModel] else {
                completion?(false, nil)
                return
            }
            
            self.configure(objects: googleModels, sheet: loadingSheet)
            self.save(objects: googleModels, forSheet: loadingSheet)
            
            progress?(CGFloat(sheetIndex + 1) / CGFloat(self.sheets.count))
            self.loadedSheet = Sheet(rawValue: self.loadedSheet.rawValue + loadingSheet.rawValue)
            
            if self.loadedSheet == .all {
                print("All loaded without errors")
                self.player = Player()
                completion?(true, nil)
            } else {
                self.loadSheet(sheetIndex: sheetIndex + 1, progress: progress, completion: completion)
            }
        }
        
    }
    
    public func parseGame(withUpdate: Bool, progress: ProgressCallback?, completion: GameCallback?) {
        reinitGame()
        
        if withUpdate {
            updateGame(progress: progress, completion: completion)
        } else {
            loadGameOffline(progress: progress, completion: completion)
        }
    }
    
    public func checkState() {
        NotificationCenter.default.post(name: GameNotificationName.update.notificationName(), object: nil)
    }
}
