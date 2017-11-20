//
//  BookTableViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    // MARK: - Storyboard
    
    struct Storyboard {
        static let bookCellIdentifier = "BookCellIdentifier"
        static let toChapterSegue = "ToChapterSegue"
        static let toVersesSegue = "ToVersesSegue"
    }
    
    //MARK: - Data
    var books: [Book]!
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.bookCellIdentifier, for: indexPath)

        if let bookCell = cell as? BookTableViewCell {
            bookCell.bookLabel.text = books[indexPath.row].fullName
        }

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if books[indexPath.row].numChapters == nil {
            performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
        }
        else if books[indexPath.row].numChapters == 1{
            performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
        }
        else {
            performSegue(withIdentifier: Storyboard.toChapterSegue, sender: self)
        }
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Storyboard.toChapterSegue) {
            if let chapterViewController = segue.destination as? ChapterTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let book = books[indexPath.row]
                    chapterViewController.book = book
                    chapterViewController.title = book.fullName
                }
            }
        }
        else if segue.identifier == Storyboard.toVersesSegue {
            if let versesViewController = segue.destination as? VersesViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                let book = books[indexPath.row]
                    versesViewController.book = book
                    versesViewController.bookId = book.id
                    versesViewController.chapterId = book.numChapters == nil ? 0 : 1
                }
            }
        }

    }
    

}
