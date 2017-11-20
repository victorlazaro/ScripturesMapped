//
//  ChapterTableViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class ChapterTableViewController: UITableViewController {

    // MARK: - Members
    var book: Book!
    var chapters: [Int] = []
    
    struct Storyboard {
        static let chapterCellIdentifier = "ChapterCelldentifier"
        static let toVersesSegue = "ToVersesSegue"
    }
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        chapters = Array(0...book.numChapters! - 1)
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
        performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toVersesSegue {
            if let versesViewController = segue.destination as? VersesViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    versesViewController.bookId = book?.id
                    versesViewController.chapterId = indexPath.row + 1
                }
            }
        }
    }
 

}
