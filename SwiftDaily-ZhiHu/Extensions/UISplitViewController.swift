//
//  UISplitViewController.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 14/07/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit

extension UISplitViewController {
    func toggleMasterView() {
        // HACK: Toggle master view in SplitViewController
        // from http://stackoverflow.com/questions/27243158/hiding-the-master-view-controller-with-uisplitviewcontroller-in-ios8
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}
