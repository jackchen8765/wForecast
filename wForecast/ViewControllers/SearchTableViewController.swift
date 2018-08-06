//
//  SearchTableViewController.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/17/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation



class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    weak var delegate : LocationSearchDelegate?
    var geocoder = CLGeocoder()
    var placeMarks =  [CLPlacemark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeMarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell", for: indexPath)

        let placeMark = self.placeMarks[indexPath.row]
        if let city = placeMark.locality,
            let state = placeMark.administrativeArea,
            let country = placeMark.country {
            if country.lowercased() == "united states" {
                cell.textLabel?.text = city + ", " + state
            }
            else {
                cell.textLabel?.text = city + ", " + country
            }
        }
        else {
            cell.textLabel?.text = self.placeMarks[indexPath.row].name ?? ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.addLocationWithPlaceMark(self.placeMarks[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            self.geocoder.geocodeAddressString(searchTerm) { (placeMarks, error) in
                if let placeMarks = placeMarks {
                    self.placeMarks = placeMarks
                    self.tableView.reloadData()
                }
            }
        }
    }

}
