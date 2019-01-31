//
//  MasterViewController.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//


import UIKit
import CoreData

class MasterViewController: UITableViewController {
  
  var detailViewController: DetailViewController? = nil
  
  let context = CoreDataStack().managedObjectContext
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var currentDateLabel: UILabel!
  
  lazy var dataSource: EntriesDataSource = {
    let request: NSFetchRequest<Entry> = Entry.fetchRequest()
    return EntriesDataSource(fetchRequest: request, managedObjectContext: self.context, tableView: self.tableView)
  }()
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  func configureView() {
    
    if let split = splitViewController {
      let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    
    addButton.image = #imageLiteral(resourceName: "Icn_write")
    
    tableView.dataSource = dataSource
    tableView.tableFooterView = UIView()
    
    let stringDate = dateToString(date: Date())
    currentDateLabel.text = stringDate
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Entries"
    searchController.searchBar.tintColor = UIColor.white
    searchController.searchBar.barStyle = .black
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
  }
  
  func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "en_US")
    let formattedDate = formatter.string(from: date)
    
    return formattedDate
  }
  
  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let object = dataSource.entries[indexPath.row]
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.entry = object
        controller.context = context
      }
    } else if segue.identifier == "addEntry" {
      let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
      controller.context = context
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 220
  }
  
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      self.dataSource.filter(byText: searchText)
    }
  }
  
}





