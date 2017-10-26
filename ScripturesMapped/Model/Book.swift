//
//  Book.swift
//  Map Scriptures
//
//  Created by Steve Liddle on 10/11/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import Foundation
import GRDB

struct Book : TableMapping, RowConvertible {
    
    // MARK: - Properties
    
    var id: Int
    var abbr: String
    var citeAbbr: String
    var fullName: String
    var numChapters: Int?
    var parentBookId: Int?
    var webTitle: String
    var tocName: String
    var subdiv: String?
    var backName: String
    var gridName: String
    var citeFull: String
    var heading2: String
    
    // MARK: - Table mapping
    
    static let databaseTableName = "book"
    
    // MARK: - Field names
    
    static let id = "ID"
    static let abbr = "Abbr"
    static let citeAbbr = "CiteAbbr"
    static let citeFull = "CiteFull"
    static let fullName = "FullName"
    static let numChapters = "NumChapters"
    static let parentBookId = "ParentBookId"
    static let webTitle = "WebTitle"
    static let tocName = "TOCName"
    static let subdiv = "Subdiv"
    static let backName = "BackName"
    static let gridName = "GridName"
    static let heading2 = "Heading2"
    
    // MARK: - Initialization
    
    init() {
        id = 0
        abbr = ""
        citeAbbr = ""
        fullName = ""
        webTitle = ""
        tocName = ""
        backName = ""
        gridName = ""
        citeFull = ""
        heading2 = ""
    }
    
    init(row: Row) {
        id = row.value(named: Book.id)
        abbr = row.value(named: Book.abbr)
        citeAbbr = row.value(named: Book.citeAbbr)
        citeFull = row.value(named: Book.citeFull)
        fullName = row.value(named: Book.fullName)
        numChapters = row.value(named: Book.numChapters)
        parentBookId = row.value(named: Book.parentBookId)
        webTitle = row.value(named: Book.webTitle)
        tocName = row.value(named: Book.tocName)
        subdiv = row.value(named: Book.subdiv)
        backName = row.value(named: Book.backName)
        gridName = row.value(named: Book.gridName)
        heading2 = row.value(named: Book.heading2)
    }
}
