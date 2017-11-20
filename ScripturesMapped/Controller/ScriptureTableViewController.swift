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
    
    // MARK: - Data
    private var volumes = GeoDatabase.sharedGeoDatabase.volumes()
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        performSegue(withIdentifier: Storyboard.toBookSegue, sender: self)
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toBookSegue {
            if let viewController = segue.destination as? BookTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    viewController.title = volumes[indexPath.row].fullName
                    viewController.books = GeoDatabase.sharedGeoDatabase.booksForParentId(indexPath.row + 1)
                }
            }
        }
    }
 

}
