//
//  AppDelegate.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/25/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    struct Storyboard {
        static let detailVCIdentifier = "MapVC"
        static let mainStoryboard = "Main"
    }
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
        }
        return true
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // landscape to portrait
        // throw away detail or put on top of the stack
        // return false to tell the split vc to push the detail vc onto the master vc's nav stack
        // return true to tell the split vc to do nothing (because we've reconfigured the master vc already)
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        // portrait to landscape
        // return nil if we want the split vc to choose a detail vc for us
        // otherwise it uses the vc we return as the new detail vc
        //      if detail not yet present, create it and return
        if let navVC = primaryViewController as? UINavigationController {
            for controller in navVC.viewControllers {
                if controller.restorationIdentifier == Storyboard.detailVCIdentifier {
                    return controller
                }
            }
        }
        let storyboard = UIStoryboard(name: Storyboard.mainStoryboard, bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: Storyboard.detailVCIdentifier)
        
        return detailView
    }
    
}

