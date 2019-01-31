//
//  LocationViewController.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//


import UIKit
import MapKit

protocol LocationViewControllerDelegate: class {
  func location(withName name: String)
}

class LocationViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var mapView: MKMapView!
  
  weak var delegate: LocationViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
  }
  
  func search() {
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = searchBar.text
    
    let activeSearch = MKLocalSearch(request: searchRequest)
    
    activeSearch.start { (response, error) in
      
      if let response = response {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        let latitude = response.boundingRegion.center.latitude
        let longitude = response.boundingRegion.center.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.title = self.searchBar.text
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func savePressed(_ sender: UIBarButtonItem) {
    sendLocationName()
  }
  
  func sendLocationName() {
    if let annotation = self.mapView.annotations.first?.title!! {
      self.delegate?.location(withName: annotation)
      
      navigationController?.popViewController(animated: true)
      dismiss(animated: true, completion: nil)
    } else {
      alertWith(title: "Alert", message: "No location chosen")
    }
  }
  
  func alertWith(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

}

extension LocationViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search()
  }

}
