//
//  GeoPlace.swift
//  Map Scriptures
//
//  Created by Steve Liddle on 10/11/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import Foundation
import GRDB

struct GeoCategory : TableMapping, RowConvertible {
    enum Category: Int {
        // Categories represent geocoded places we've constructed from various
        // Church history sources (1) or the Open Bible project (2)
        case churchHistory = 1,
        openBible = 2
    }
    
    var id: Int
    var category: Category
    
    static let databaseTableName = "geocategory"
    
    static let id = "Id"
    static let category = "Category"
    
    init(row: Row) {
        id = row.value(named: GeoCategory.id)
        category = Category(rawValue: row.value(named: GeoCategory.category))!
    }
}

struct GeoPlace : TableMapping, RowConvertible {
    enum GeoFlag: String {
        // Flags indicate different levels of certainty in the Open Bible database
        case None = "",
        Open1 = "~",
        Open2 = ">",
        Open3 = "?",
        Open4 = "<",
        Open5 = "+"
    }
    
    var id: Int
    var placename: String
    var latitude: Double
    var longitude: Double
    var flag: GeoFlag
    var viewLatitude: Double?
    var viewLongitude: Double?
    var viewTilt: Double?
    var viewRoll: Double?
    var viewAltitude: Double?
    var viewHeading: Double?
    var category: GeoCategory.Category!
    
    static let databaseTableName = "geoplace"
    
    static let id = "Id"
    static let placename = "Placename"
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let flag = "Flag"
    static let viewLatitude = "ViewLatitude"
    static let viewLongitude = "ViewLongitude"
    static let viewTilt = "ViewTilt"
    static let viewRoll = "ViewRoll"
    static let viewAltitude = "ViewAltitude"
    static let viewHeading = "ViewHeading"
    static let category = "Category"
    
    init(row: Row) {
        id = row.value(named: GeoPlace.id)
        placename = row.value(named: GeoPlace.placename)
        latitude = row.value(named: GeoPlace.latitude)
        longitude = row.value(named: GeoPlace.longitude)
        category = GeoCategory.Category(rawValue: row.value(named: GeoPlace.category))
        
        if let geoFlag = row.value(named: GeoPlace.flag) as? String {
            flag = GeoFlag(rawValue: geoFlag)!
        } else {
            flag = GeoFlag.None
        }
        
        if let vLatitude = row.value(named: GeoPlace.viewLatitude) as? Double {
            viewLatitude = vLatitude
            viewLongitude = row.value(named: GeoPlace.viewLongitude)
            viewTilt = row.value(named: GeoPlace.viewTilt)
            viewRoll = row.value(named: GeoPlace.viewRoll)
            viewAltitude = row.value(named: GeoPlace.viewAltitude)
            viewHeading = row.value(named: GeoPlace.viewHeading)
        }
    }
}

struct GeoTag : TableMapping, RowConvertible {
    var geoplaceId: Int
    var scriptureId: Int
    var startOffset: Int
    var endOffset: Int
    
    static let databaseTableName = "geotag"
    
    static let geoplaceId = "GeoplaceId"
    static let scriptureId = "ScriptureId"
    static let startOffset = "StartOffset"
    static let endOffset = "EndOffset"
    
    init(row: Row) {
        geoplaceId = row.value(named: GeoTag.geoplaceId)
        scriptureId = row.value(named: GeoTag.scriptureId)
        startOffset = row.value(named: GeoTag.startOffset)
        endOffset = row.value(named: GeoTag.endOffset)
    }
}
