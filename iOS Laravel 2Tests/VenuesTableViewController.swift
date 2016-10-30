//
//  VenuesTableViewController.swift
//  VenueExplorer
//
//  Created by Duc Tran on 8/28/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import UIKit
import SafariServices
import MapKit
import CoreLocation
class VenuesTableViewController : UITableViewController
{
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    var venues: [Venue] = [] {
        didSet {
            self.tableView.reloadData()
            self.addMapAnnotations()
        }
    }
    
    var coordinate: Coordinate? {
        didSet {
            self.fetchVenues()
        }
    }
    let locationManager = LocationManager()
    var clientID: String = "DGN3GZBDNF2YAGK5I4XBYEBKE25Z2WK2JXNSJKI41XWMIP3P"
    var clientSecret: String = "OIHLPZPMUIUV11S5GJL5IXR2OZVOZRVQPHD455AS312WXAJ4"
    var foursquareClient: FoursquareClient!
    let searchController = UISearchController(searchResultsController: nil)
    
    struct Storyboard {
        static let venueCell = "VenueCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foursquareClient = FoursquareClient(clientID: clientID, clientSecret: clientSecret)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Location Service
        locationManager.getPermission()
        locationManager.didGetLocation = { [weak self] coordinate in
            self?.coordinate = coordinate
        }
        
        mapView.delegate = self
        
        // Configure Search Bar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        headerStackView.addSubview(searchController.searchBar)
    }
    
    @IBAction func fetchVenues()
    {
        if let coordinate = coordinate {
            foursquareClient.fetchVenuesFor(coordinate: coordinate, completion: { (result) in
                switch result {
                case .success(let venues):
                    self.venues = venues
                    self.refreshControl?.endRefreshing()
                case .failure(let error):
                    // CHALLENGE: display an alert view to show error. error.localizedDescription
                    print(error)
                }
            })
        }
    }
    
    // MARK: - Map Annotations
    
    func addMapAnnotations()
    {
        self.removeAnnotations()
        // (1) loop thorugh venues
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map({ venue in
                // (2) create an annotation object
                let point = MKPointAnnotation()
                if let coordinate = venue.location?.coordinate {
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    point.title = venue.name
                    point.subtitle = venue.categoryName
                }
                
                return point
            })
            
            // (3) add annotations to the mapview
            mapView.addAnnotations(annotations)
        }
    }
    
    func removeAnnotations()
    {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension VenuesTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.venueCell, for: indexPath) as! VenueTableViewCell
        let venue = venues[indexPath.row]
        
        cell.foursquareClient = self.foursquareClient
        cell.venue = venue
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VenuesTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let venue = self.venues[indexPath.row]
        if let url = venue.url {
            // display a safari VC
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            // alert the user that there's no webpage for this venue
            let alertController = UIAlertController(title: "Ooops!", message: "Looks like the venue doesn't provide a website", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - MKMapViewDelegate

extension VenuesTableViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.0001
        region.span.longitudeDelta = 0.0001
        
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension VenuesTableViewController : UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if let coordinate = coordinate {
            foursquareClient.fetchVenuesFor(coordinate: coordinate, query: searchController.searchBar.text, completion: { (result) in
                switch result {
                case .success(let venues):
                    self.venues = venues
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}


















