//
//  AppDelegate.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 5/29/15
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            setUpSplitViewController(splitViewController)
        }

        UserPreferences.registerDefaults()

        return true
    }
}

extension AppDelegate {
    private func setUpSplitViewController(svc: UISplitViewController) {
        // TODO: Check whether next two lines is needed.
        let navigationController = svc.viewControllers[svc.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()

        svc.preferredDisplayMode = .AllVisible
        svc.delegate = self
    }
}

// MARK: - Split View Delegate
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? RealmNewsViewController {
                if topAsDetailController.newsId == nil {
                    // Without this, RealmNewsViewController is first shown when on iPhone.
                    return true
                }
            }
        }

        return false
    }
}
