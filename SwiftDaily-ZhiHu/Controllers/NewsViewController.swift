//
//  NewsViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 27/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    // MARK: UI
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewTopConstraint: NSLayoutConstraint!

    deinit {
        stopFollowingScrollView()
    }
}

extension NewsViewController {
    func loadNews() {
    }
}

// MARK: UI
extension NewsViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        followScrollView(webView, usingTopConstraint: webViewTopConstraint)

        loadNews()
    }

    override func viewWillDisappear(animated: Bool) {
        showNavBarAnimated(false)

        saveReadingProgress()

        super.viewWillDisappear(animated)
    }

    func saveReadingProgress() {
        let offset = webView.scrollView.contentOffset.y
        let height = webView.scrollView.contentSize.height
        let percentage = Double(offset/height)
        print("height: \(height), offset: \(offset), \(percentage*100)% read")

        // TODO: Actually save the percentage
    }

    func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
}
