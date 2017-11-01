//
//  ScriptureTableViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/25/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class ScriptureTableViewController: UITableViewController {

    
    
    // MARK: -  Storyboard
    struct Storyboard {
        static let scriptureCellIdentifier = "VolumeCellIdentifier"
        static let toBookSegue = "ToBookSegue"
    }
    
    // MARK: - Database
    private let database = GeoDatabase.sharedGeoDatabase
    
    
    // MARK: - Data
    private var volumes: [Book] = []
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumes = database.volumes()
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return volumes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.scriptureCellIdentifier, for: indexPath)

        if let scriptureCell = cell as? ScriptureTableViewCell {
            scriptureCell.scriptureLabel.text = volumes[indexPath.row].fullName
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: Storyboard.toBookSegue, sender: self)
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let viewController = segue.destination as? BookTableViewController {
            viewController.volume = volumes[selectedIndex!]
        }
    }
 

}
