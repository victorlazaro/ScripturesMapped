//
//  GeoDatabase.swift
//  Map Scriptures
//
//  Created by Steve Liddle on 11/5/14.
//  Copyright (c) 2014 IS 543. All rights reserved.
//

import Foundation
import GRDB

class GeoDatabase {

    // MARK: - Constants

    struct Constant {
        static let fileName = "geo.21"
        static let fileExtension = "sqlite"
    }
    
    // MARK: - Properties

    var dbQueue: DatabaseQueue!

    // MARK: - Singleton

    // See http://bit.ly/1tdRybj for a discussion of this singleton pattern.
    static let sharedGeoDatabase = GeoDatabase()

    fileprivate init() {
        // This guarantees that code outside this file can't instantiate a GeoDatabase.
        // So others must use the sharedGeoDatabase singleton.
        dbQueue = try? DatabaseQueue(path: Bundle.main.path(forResource: Constant.fileName,
                                                            ofType: Constant.fileExtension)!)
    }

    // MARK: - Helpers

    //
    // Return a Book object for the given book ID.
    //
    func bookForId(_ bookId: Int) -> Book {
        return dbQueue.inDatabase { (db: Database) -> Book in
            if let row = Row.fetchOne(db,
                                      "select * from \(Book.databaseTableName) " +
                                      "where \(Book.id) = ?",
                                      arguments: [ bookId ]) {
                return Book(row: row)
            }

            return Book()
        }
    }

    //
    // Return array of Book objects for the given volume ID (i.e. parent book ID).
    //
    func booksForParentId(_ parentBookId: Int) -> [Book] {
        return dbQueue.inDatabase { (db: Database) -> [Book] in
            var books = [Book]()
            
            for row in Row.fetchAll(db,
                                    "select * from \(Book.databaseTableName) " +
                                    "where \(Book.parentBookId) = ? order by \(Book.id)",
                                    arguments: [ parentBookId ]) {
                books.append(Book(row: row))
            }

            return books
        }
    }

    //
    // Return the GeoPlace corresponding to the given ID.
    //
    func geoPlaceForId(_ geoplaceId: Int) -> GeoPlace? {
        return dbQueue.inDatabase { (db: Database) -> GeoPlace? in
            if let row = Row.fetchOne(db,
                                      "select * from \(GeoPlace.databaseTableName) " +
                                      "where \(GeoPlace.id) = ?", arguments: [ geoplaceId ]) {
                return GeoPlace(row: row)
            }
            
            return nil
        }
    }

    //
    // Return a query that will generate the join of geotags and geoplaces for
    // a given scripture ID.
    //
    func geoTagsForScriptureId(_ scriptureId: Int) -> [(GeoPlace, GeoTag)] {
        return dbQueue.inDatabase { (db: Database) -> [(GeoPlace, GeoTag)] in
            var geotags = [(GeoPlace, GeoTag)]()
            
            for row in Row.fetchAll(db,
                                    "select * from \(GeoTag.databaseTableName) " +
                                    "join \(GeoPlace.databaseTableName) " +
                                    "where \(GeoTag.geoplaceId) = \(GeoPlace.id) " +
                                        "and \(GeoTag.scriptureId) = ? " +
                                    "order by \(GeoTag.endOffset) desc",
                                    arguments: [ scriptureId ]) {
                geotags.append((GeoPlace(row: row), GeoTag(row: row)))
            }

            return geotags
        }
    }

    //
    // Return a query that will generate all verses for a given book ID and chapter.
    //
    func versesForScriptureBookId(_ bookId: Int, _ chapter: Int) -> [Scripture] {
        return dbQueue.inDatabase { (db: Database) -> [Scripture] in
            var verses = [Scripture]()

            for row in Row.fetchAll(db,
                                    "select * from \(Scripture.databaseTableName) " +
                                    "where \(Scripture.bookId) = ? and \(Scripture.chapter) = ? " +
                                    "order by \(Scripture.verse)",
                                    arguments: [ bookId, chapter ]) {
                verses.append(Scripture(row: row))
            }

            return verses
        }
    }

    //
    // Return an array of strings listing the titles of all scripture volumes.
    //
    func volumes() -> [String] {
        // NEEDSWORK: replace this with code to read the volume titles from the database

        return ["Old Testament", "New Testament", "Book of Mormon",
                "Doctrine and Covenants", "Pearl of Great Price"]
    }
}
