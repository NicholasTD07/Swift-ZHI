//
//  NewsViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 12/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI

class NewsViewController: UIViewController {
    var store: DailyInMemoryStore!
    var newsId: Int!

    // MARK: UI
    var newsBody: String!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
}

// MARK: UI
extension NewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer()
        panGestureRecognizer.edges = .Left
        panGestureRecognizer.addTarget(self, action: "goBackToDailyView")

        view.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator.startAnimating()

        loadNews()
    }


    func goBackToDailyView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func loadNews() {
        store.news(newsId) {[weak self] news in
            guard let i = self else { return }

            i.stopIndicator()

            // TODO: consider move this into model extension
            let css = news.cssURLs.map { "<link rel='stylesheet' type='text/css' href='\($0.absoluteString)'>" }
            i.newsBody = css.reduce(news.body) { $0 + $1 }
            // hide 200px #div.img-place-holder in css
            i.newsBody.extend("<style>.headline .img-place-holder {\n height: 0px;\n}</style>")

            i.webView.loadHTMLString(i.newsBody, baseURL: nil)
        }
    }

    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
}