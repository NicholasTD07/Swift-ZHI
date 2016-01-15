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

extension HideNavBarViewController: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        // NOTE: Must set self to scrollView's delegate 
        showNavbar()

        return true
    }
}

// MARK: GestureRecognizer Delegate
extension DailyTableViewController {
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {


        if isPanningHorizontally(gestureRecognizer) {
            return false
        }


        return super.gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: otherGestureRecognizer)
    }

    private func isPanningHorizontally(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let view = recognizer.view
            if let superView = view?.superview {
                let translation = recognizer.translationInView(superView)
                if fabs(translation.x) > fabs(translation.y) {
                    return true
                }
            }
        }

        return false
    }
}
