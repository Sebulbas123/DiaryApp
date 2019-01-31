//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//


import Foundation
import CoreData

class CoreDataStack {
  
  static let sharedInstance = CoreDataStack()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let container = self.persistentContainer
    return container.viewContext
  }()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DiaryApp")
    container.loadPersistentStores() { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error: \(error), \(error.userInfo)")
      }
      
    }
    
    return container
  }()
    
}

extension NSManagedObjectContext {
  func saveChanges() {
    if self.hasChanges {
      do {
        try save()
      } catch {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
}
