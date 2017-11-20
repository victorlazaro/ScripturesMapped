//
//  VersesViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit
import WebKit

class VersesViewController: UIViewController, WKNavigationDelegate {

    
    // MARK: - Storyboard
    struct Storyboard {
        static let toMapSegue = "ToMapSegue"
    }
    
    // MARK: - Outlets

    @IBOutlet weak var webViewOutlet: WKWebView!
    
    // MARK: - Actions
    @IBAction func mapButton(_ sender: UIBarButtonItem) {
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            self.mapViewController = (controllers[controllers.count-1] as!
//                                        UINavigationController).topViewController as? MapViewController
//        }
        performSegue(withIdentifier: Storyboard.toMapSegue, sender: self)

    }
    
    // MARK: - Members
    
    var geoPlaces: [GeoPlace] = []
    var bookId: Int?
    var chapterId: Int?
    var text = ""
    var book: Book?
    var mapViewController: MapViewController? = nil
    var database = GeoDatabase.sharedGeoDatabase

    // MARK: - View Controller lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureDetailViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewOutlet.navigationDelegate = self
        
        configureDetailViewController()
        
        if let bId = bookId, let cId = chapterId {
            book = GeoDatabase.sharedGeoDatabase.bookForId(bookId!)
            let subdiv = book?.subdiv ?? "Chapter"
            self.navigationItem.title = cId == 0 ? book?.fullName : "\(subdiv) \(cId)"
            (text, geoPlaces) = ScriptureRenderer.sharedRenderer.htmlForBookId(bId, chapter: cId)
            if (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController is MapViewController {
                 performSegue(withIdentifier: Storyboard.toMapSegue, sender: self)
            }
            
        }
        webViewOutlet.loadHTMLString(text, baseURL: nil)

    }
    
    private func configureDetailViewController() {
        if let splitVC = splitViewController {
            if let navVC = splitVC.viewControllers.last as? UINavigationController {
                mapViewController = navVC.topViewController as? MapViewController
            } else {
                mapViewController = splitVC.viewControllers.last as? MapViewController
            }
        } else {
            mapViewController = nil
        }
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let path = navigationAction.request.url?.absoluteString {
                if path.hasPrefix(ScriptureRenderer.Constant.baseUrl) {
                    if let mapVC = mapViewController {
                        let geoPlaceId = Int(path.split(separator: "/")[3])
                        let place = geoPlaceForId(geoPlaceId!)
                        mapVC.singleGeoPlace = place
                        (mapVC as MapViewController).centerOnGeoPlace(place)
                    }
                    else {
                        performSegue(withIdentifier: Storyboard.toMapSegue, sender: path)
                    }
                    
                    decisionHandler(.cancel)
                    return
                }
            }
            return
        decisionHandler(.allow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toMapSegue {
            let navVC = segue.destination as? UINavigationController
            if let mapVC = navVC?.topViewController as? MapViewController {
                
                if let path = sender as? String {
                    let geoPlaceId = Int(path.split(separator: "/")[3])
                    mapVC.singleGeoPlace = geoPlaceForId(geoPlaceId!)
                }
                else {
                    mapVC.geoPlaces = geoPlaces
                }
            }

        }
    }
    
    private func geoPlaceForId(_ placeId : Int) -> GeoPlace {
        for geoPlace in geoPlaces {
            if geoPlace.id == placeId {
                return geoPlace
            }
        }
        return database.geoPlaceForId(placeId)!
    }
    
}


