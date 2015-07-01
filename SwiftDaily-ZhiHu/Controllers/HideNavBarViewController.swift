//
//  HideNavBarViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 1/07/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import AMScrollingNavbar


class HideNavBarViewController: HidesHairLineUnderNavBarViewController {
    @IBOutlet weak var scrollableView: UIView!
    @IBOutlet weak var scrollableViewTopConstraint: NSLayoutConstraint!

    deinit {
        stopFollowingScrollView()
    }
}

// MARK: UI methods
extension HideNavBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        followScrollView(scrollableView, usingTopConstraint: scrollableViewTopConstraint)

    }

    override func viewWillDisappear(animated: Bool) {
        showNavBarAnimated(false)

        super.viewWillDisappear(animated)
    }
}
