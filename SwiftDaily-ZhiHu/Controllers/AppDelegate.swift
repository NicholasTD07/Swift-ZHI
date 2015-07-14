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
        let splitViewController = window!.rootViewController as! UISplitViewController

        setUpSplitViewController(splitViewController)

        return true
    }
}

extension AppDelegate {
    private func setUpSplitViewController(svc: UISplitViewController) {
        svc.preferredDisplayMode = .AllVisible
        svc.delegate = self
    }
}

// MARK: - Split View Delegate
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? RealmNewsViewController else { return false }
        if topAsDetailController.newsId == nil {
            // Without this, RealmNewsViewController is first shown when on iPhone.
            return true
        }

        return false
    }
}

