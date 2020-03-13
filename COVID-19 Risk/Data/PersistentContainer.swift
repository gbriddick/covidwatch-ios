//
//  Created by Zsombor Szabo on 12/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import os.log

public class PersistentContainer: NSPersistentContainer {
    
    static let modelName = "COVID_19_Risk"
    
    static let log = OSLog(subsystem: modelName, category: String(describing: PersistentContainer.self))
    
    public static var shared = PersistentContainer(name: modelName)
    
    public var isLoaded = false
    
    public var isLoading = false
    
    public var loadError: Error? //= (CocoaError(.coderInvalidValue) as NSError)
    
    var loadCompletionHandlers = [((Error?) -> Void)]()
    
    public func load(_ completionHandler: @escaping (Error?) -> Void) {
        let container = self
        if let error = container.loadError {
            DispatchQueue.main.async { completionHandler(error) }
            return
        }
        guard !container.isLoaded else {
            DispatchQueue.main.async { completionHandler(nil) }
            return
        }
        container.loadCompletionHandlers.append(completionHandler)
        guard !container.isLoading else {
            return
        }
        container.isLoading = true
        
        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        os_log("Loading persistent stores...", log: PersistentContainer.log)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            defer {
                container.isLoading = false
                container.loadCompletionHandlers.forEach { $0(error) }
            }
            if let error = error {
                os_log("Loading persistent stores failed: %@", log: PersistentContainer.log, type: .error, error as CVarArg)
                container.loadError = error
                return
            }
            container.isLoaded = true
            os_log("Loading persistent stores completed.", log: PersistentContainer.log)
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
    }
    
    public func delete() {
        let fileManager = FileManager.default
        do {
            let applicationDataDirectoryURL = PersistentContainer.defaultDirectoryURL()
            let dataPath = applicationDataDirectoryURL.appendingPathComponent("\(PersistentContainer.modelName).sqlite").path
            if fileManager.fileExists(atPath: dataPath) {
                try fileManager.removeItem(atPath: dataPath)
            }
            let shmPath = applicationDataDirectoryURL.appendingPathComponent("\(PersistentContainer.modelName).sqlite-shm").path
            if fileManager.fileExists(atPath: shmPath) {
                try fileManager.removeItem(atPath: shmPath)
            }
            let walPath = applicationDataDirectoryURL.appendingPathComponent("\(PersistentContainer.modelName).sqlite-wal").path
            if fileManager.fileExists(atPath: walPath) {
                try fileManager.removeItem(atPath: walPath)
            }
        }
        catch {
            os_log("Deleting data failed: %@", log: PersistentContainer.log, type: .error, error as CVarArg)
        }
    }
    
    func saveContext () {
        let context = self.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                UIApplication.shared.topViewController?.present(error as NSError, animated: true)
            }
        }
    }
}
