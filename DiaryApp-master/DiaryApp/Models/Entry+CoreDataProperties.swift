//
//  Entry+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//


import UIKit
import CoreData
import Foundation

enum Emoticon: Int32 {
  case bad
  case average
  case happy
}

extension Entry {
  
  static let identifier = "Entry"
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
    let request = NSFetchRequest<Entry>(entityName: "Entry")
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    request.sortDescriptors = [sortDescriptor]
    return request
  }
  
  @NSManaged public var creationDate: Date
  @NSManaged public var imageData: NSData?
  @NSManaged public var locationName: String?
  @NSManaged public var contentText: String
  @NSManaged public var emoticon: Int32
  
  var emoticonStatus: Emoticon {
    set {
      self.emoticon = newValue.rawValue
    }
    get {
      return Emoticon(rawValue: self.emoticon)!
    }
  }
}

extension Entry {
  static var entityName: String {
    return String(describing: Entry.self)
  }
  
  @nonobjc class func createWith(image: UIImage?, locationName: String?, content: String, emoticon: Emoticon, in context: NSManagedObjectContext) -> Entry {
    let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as! Entry
        
    entry.creationDate = Date()
    
    if let image = image {
      entry.imageData = UIImageJPEGRepresentation(image, 1.0)! as NSData
    }
    
    entry.locationName = locationName
    entry.contentText = content
    entry.emoticonStatus = emoticon
    
    return entry
  }
  
  @nonobjc class func update(_ entry: Entry, withImage image: UIImage?, locationName: String?, content: String, emoticon: Emoticon, in context: NSManagedObjectContext) -> Entry {
    
    if let image = image {
      entry.imageData = UIImageJPEGRepresentation(image, 1.0)! as NSData
    }
    
    entry.contentText = content
    entry.emoticonStatus = emoticon
    entry.locationName = locationName
    
    return entry
  }
}

extension Entry {
  var image: UIImage {
    if let imageData = self.imageData {
      return UIImage(data: imageData as Data)!
    }
    return #imageLiteral(resourceName: "icn_noimage")
  }
}





