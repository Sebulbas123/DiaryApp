//
//  EntriesDataSource.swift
//  DiaryApp
//
//  Created by Michele Mola on 08/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import UIKit
import CoreData

class EntriesDataSource: NSObject, UITableViewDataSource {
  private let tableView: UITableView
  private var fetchedResultsController: EntriesFetchedResultsController
  
  init(fetchRequest: NSFetchRequest<Entry>, managedObjectContext context: NSManagedObjectContext, tableView: UITableView) {
    self.tableView = tableView
    self.fetchedResultsController = EntriesFetchedResultsController(request: fetchRequest, context: context)
    super.init()
    
    self.fetchedResultsController.delegate = self
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let entryCell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
    
    let entry = fetchedResultsController.object(at: indexPath)
    entryCell.configureCell(entry: entry)

    return entryCell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "My thoughts"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let context = fetchedResultsController.managedObjectContext
      context.delete(fetchedResultsController.object(at: indexPath))
      
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func filter(byText text: String) {
    if text.isEmpty || text.count < 2 {
      self.fetchedResultsController.fetchRequest.predicate = nil
    } else {
      let predicate = NSPredicate(format: "contentText contains[c] %@", text)
      self.fetchedResultsController.fetchRequest.predicate = predicate
    }
    
    self.fetchedResultsController.fetch()
        
    tableView.reloadData()
  }

}

extension EntriesDataSource: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.reloadData()
  }
}

extension EntriesDataSource {
  var entries: [Entry] {
    guard let objects = fetchedResultsController.sections?.first?.objects as? [Entry] else {
      return []
    }
    
    return objects
  }
}


