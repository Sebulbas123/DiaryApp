//
//  EntriesFetchedResultsController.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//

import CoreData

class EntriesFetchedResultsController: NSFetchedResultsController<Entry> {
  init(request: NSFetchRequest<Entry>, context: NSManagedObjectContext) {
    super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    fetch()
  }
  
  func fetch() {
    do {
      try performFetch()
    } catch {
      fatalError()
    }
  }
}
