//
//  VersesViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class VersesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var textOutlet: UITextView!
    var geoPlaces: [GeoPlace] = []
    var bookId: Int?
    var chapterId: Int?
    var text = ""
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let bId = bookId, let cId = chapterId {
            book = GeoDatabase.sharedGeoDatabase.bookForId(bookId!)
            let subdiv = book?.subdiv ?? "Chapter"
            self.navigationItem.title = cId == 0 ? book?.fullName : "\(subdiv) \(cId)"
            (text, geoPlaces) = ScriptureRenderer.sharedRenderer.htmlForBookId(bId, chapter: cId)
        }
        textOutlet.attributedText = getHtmlAttrString()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textOutlet.contentOffset = CGPoint.zero
    }
    
    func getHtmlAttrString() -> NSAttributedString? {
        do {
            let str = try NSAttributedString(data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html,
                                  .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return str
        } catch {
            print(error)
        }
        return nil
    }
}


