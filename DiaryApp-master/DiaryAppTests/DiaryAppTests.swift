//
//  DiaryAppTests.swift
//  DiaryAppTests
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//

import XCTest
import CoreData
@testable import DiaryApp

class DiaryAppTests: XCTestCase {
  
  var persistentStore: NSPersistentStore!
  var storeCoordinator: NSPersistentStoreCoordinator!
  var managedObjectContext: NSManagedObjectContext!
  var managedObjectModel: NSManagedObjectModel!
  
  var fakeEntry: Entry!
  var dataController = CoreDataStack.sharedInstance
  
  // Setup fetchedResultsController
  lazy var fetchedResultsController: EntriesFetchedResultsController = {
    let request = NSFetchRequest<Entry>(entityName: "Entry")
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    request.sortDescriptors = [sortDescriptor]
    let fetchedResultsController = EntriesFetchedResultsController(request: request, context: dataController.managedObjectContext)
    return fetchedResultsController
  }()
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
    storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    do{
      try  persistentStore = storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
      managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = storeCoordinator
    }
    catch{
      print("Unresolved error \(error)")
    }
    
    dataController.managedObjectContext = managedObjectContext
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    managedObjectModel = nil
    managedObjectContext = nil
    persistentStore = nil
    storeCoordinator = nil
    fakeEntry = nil
    super.tearDown()
  }
  
  func createEntry() {
    
    fakeEntry = NSEntityDescription.insertNewObject(forEntityName: Entry.identifier, into: managedObjectContext!) as! Entry
    
    fakeEntry.creationDate = Date()
    fakeEntry.contentText = "Hello guys"
    fakeEntry.emoticonStatus = .happy
    fakeEntry.locationName = "Naples"
    
    dataController.managedObjectContext.saveChanges()
  }
  
  func testNewEntry() {
    createEntry()
    
    let contentText = "Hello guys"
    let emoticonStatus: Emoticon = .happy
    let locationName = "Naples"
    
    XCTAssertEqual(contentText, fakeEntry.contentText)
    XCTAssertEqual(emoticonStatus, fakeEntry.emoticonStatus)
    XCTAssertEqual(locationName, fakeEntry.locationName)
  }
  
  func testEdit() {
    createEntry()
    
    fakeEntry.locationName = "Naples"
    let editedLocation = "Naples"
    
    XCTAssertEqual(editedLocation, fakeEntry.locationName)
  }
  
  func testDelete(){
    
    createEntry()
    
    XCTAssert(fetchedResultsController.fetchedObjects?.count == 1, "More or less than 1 entry found")
    
    if let entry = fetchedResultsController.fetchedObjects?.first {
      dataController.managedObjectContext.delete(entry)
      dataController.managedObjectContext.saveChanges()
    }
    
    XCTAssert(fetchedResultsController.fetchedObjects?.count == 1, "Delete failed, more than 0 entries found")
    
  }
  
  func testDate() {
    createEntry()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    
    let entryDate = fakeEntry.creationDate
    let formattedEntryDate = dateFormatter.string(from: entryDate)
    
    let date = Date()
    let formattedTestDate = dateFormatter.string(from: date)
    
    XCTAssertEqual(formattedEntryDate, formattedTestDate)
  }
}
