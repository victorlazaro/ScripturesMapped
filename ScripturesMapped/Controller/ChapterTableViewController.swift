//
//  ChapterTableViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class ChapterTableViewController: UITableViewController {

    
    var book: Book?
    var chapters: [Int] = []
    var selectedIndex = 0
    
    struct Storyboard {
        static let chapterCellIdentifier = "ChapterCelldentifier"
        static let toVersesSegue = "ToVersesSegue"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scriptureBook = book else {
            return
        }
        
        //TODO handle title page, things that don't have chapters/sections.
        chapters = Array(0...scriptureBook.numChapters! - 1)
        
        self.navigationItem.title = scriptureBook.fullName
        
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.chapterCellIdentifier, for: indexPath)

        if let chapterCell = cell as? ChapterTableViewCell {
            if let scriptureBook = book {
                let prefix = scriptureBook.subdiv ?? "Chapter"
                chapterCell.chapterLabel.text = "\(prefix) \(chapters[indexPath.row] + 1)"
            }
        }
        return cell
    }
 
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toVersesSegue {
            if let versesViewController = segue.destination as? VersesViewController {
                versesViewController.bookId = book?.id
                versesViewController.chapterId = selectedIndex + 1
            }
        }
    }
 

}
