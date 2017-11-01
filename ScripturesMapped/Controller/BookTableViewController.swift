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
    var volume: Book?
    var books: [Book] = []
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = volume?.fullName
        books = GeoDatabase.sharedGeoDatabase.booksForParentId((volume?.id)!)
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
        selectedIndex = indexPath.row
        if books[selectedIndex!].numChapters == nil {
            performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
        }
        else if books[selectedIndex!].numChapters == 1{
            performSegue(withIdentifier: Storyboard.toVersesSegue, sender: self)
        }
        else {
            performSegue(withIdentifier: Storyboard.toChapterSegue, sender: self)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Storyboard.toChapterSegue) {
            if let chapterViewController = segue.destination as? ChapterTableViewController {
                chapterViewController.book = books[selectedIndex!]
            }
        }
        else if segue.identifier == Storyboard.toVersesSegue {
            if let versesViewController = segue.destination as? VersesViewController {
                let book = books[selectedIndex!]
                versesViewController.book = book
                versesViewController.bookId = book.id
                versesViewController.chapterId = book.numChapters == nil ? 0 : 1
            }
        }

    }
    

}
