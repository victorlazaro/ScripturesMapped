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
        static let scriptureCellIdentifier = "ScriptureCellIdentifier"
    }
    
    // MARK: - Database
    private let database = GeoDatabase.sharedGeoDatabase
    
    
    // MARK: - Data
    private var dataToDisplay: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataToDisplay = database.volumes()
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataToDisplay.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.scriptureCellIdentifier, for: indexPath)

        if let scriptureCell = cell as? ScriptureTableViewCell {
            scriptureCell.scriptureLabel.text = dataToDisplay[indexPath.row]
        }

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
