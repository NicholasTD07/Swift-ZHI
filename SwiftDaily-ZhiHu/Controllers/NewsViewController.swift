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
}

// MARK: Abstract methods
extension NewsViewController {
    func loadNews() {
    }
}


// MARK: Scorll View Delegate
extension NewsViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if splitViewController?.displayMode == .AllVisible {
            splitViewController?.toggleMasterView()
        }
    }
}

// MARK: UI methods
extension NewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scrollView.delegate = self
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    }

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
