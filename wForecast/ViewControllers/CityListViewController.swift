//
//  CityListViewController.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/16/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationSearchDelegate: class {
    func addLocationWithPlaceMark(_ placeMark: CLPlacemark)
}

class CityListViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, LocationSearchDelegate  {
    //MARK: Properties
    
    static let MAX_CITY_COUNT = 8

    weak var delegate: PlaceMarkChangeDelegate?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var searchController : UISearchController!
    var searchTableViewController : SearchTableViewController!
    
    var geocoder = CLGeocoder()
    
    var placeMarks : [CLPlacemark]!
    var selected = 0
    
    var searchResults = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = "Cities"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchTableViewController = UIStoryboard(name: StoryboardName.CITYSEARCH, bundle: nil).instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        searchTableViewController.delegate = self
            
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.searchResultsUpdater = searchTableViewController
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Name of City"
        searchController.searchBar.isHidden = true
        searchController.searchBar.showsCancelButton = true
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper
    
    func updateUIStatus() {
        if self.placeMarks.count < CityListViewController.MAX_CITY_COUNT {
            self.addButton.isEnabled = true
        }
        else {
            self.addButton.isEnabled = false
        }
    }
    
    func showSearchController() {
        self.searchResults = []
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, we place the search bar in the navigation bar.
            navigationController?.navigationBar.prefersLargeTitles = false
            
            navigationItem.searchController = searchController
            
            // We want the search bar visible all the time.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, we place the search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
            //navigationItem.titleView = searchController.searchBar
        }
        
        /** Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true
        searchController.searchBar.isHidden = false
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.tableView.tableHeaderView = nil
        searchController.searchBar.isHidden = true
        
        self.updateUIStatus()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.placeMarks.count > 0 {
            return 1
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeMarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath) as! CityListTableViewCell
        
        let placeMark = self.placeMarks![indexPath.row]
        if let city = placeMark.locality,
            let state = placeMark.administrativeArea,
            let country = placeMark.country {
            if country.lowercased() == "united states" {
                cell.cityLabel?.text = city + ", " + state
            }
            else {
                cell.cityLabel?.text = city + ", " + country
            }
        }
        else {
            cell.cityLabel?.text = self.placeMarks![indexPath.row].name ?? ""
        }

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.placeMarks!.remove(at: indexPath.row)
            self.delegate?.didRemovePlaceMark(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: LocationSearchDelegate
    
    func addLocationWithPlaceMark(_ placeMark: CLPlacemark) {
        guard self.placeMarks.count < CityListViewController.MAX_CITY_COUNT else {
            return
        }
        
        for place in self.placeMarks {
            if place.locality == placeMark.locality &&
                place.administrativeArea == placeMark.administrativeArea &&
                place.country == placeMark.country {
                return;
            }
        }
        self.placeMarks.append(placeMark)
        self.delegate?.didAddPlaceMark(placeMark)
    
        searchController.searchBar.text = nil
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            self.selected = indexPath.row
        }
        
    }
    
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hideSearchController()
    }
    
    
    
    //MARK: UISearchControllerDelegate
    func presentSearchController(_ searchController: UISearchController) {

    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
 
    
    
    //MARK: Action
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        self.showSearchController()
        sender.isEnabled = false
    }
    
}
