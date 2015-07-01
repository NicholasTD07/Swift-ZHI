//
//  NewsViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 27/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class NewsViewController: HideNavBarViewController {
    // MARK: UI
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!

    deinit {
        stopFollowingScrollView()
    }
}

// MARK: Abstract methods
extension NewsViewController {
    func loadNews() {
    }
}

// MARK: UI methods
extension NewsViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadNews()
    }

    override func viewWillDisappear(animated: Bool) {
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
