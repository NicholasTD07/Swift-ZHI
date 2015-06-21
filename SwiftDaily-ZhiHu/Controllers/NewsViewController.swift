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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        loadNews()
    }


    func goBackToDailyView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func loadNews() {
        if let news = store.news[newsId] {
            loadNews(news)
            return
        } else {
            activityIndicator.startAnimating()
            store.news(newsId) {[weak self] news in
                guard let i = self else { return }

                i.stopIndicator()
                i.loadNews(news)
            }
        }
    }

    private func loadNews(news: News) {
        // TODO: consider move this into model extension
        let css = news.cssURLs.map { "<link rel='stylesheet' type='text/css' href='\($0.absoluteString)'>" }
        newsBody = css.reduce(news.body) { $0 + $1 }
        // hide 200px #div.img-place-holder in css
        newsBody.extend("<style>.headline .img-place-holder {\n height: 0px;\n}</style>")

        webView.loadHTMLString(newsBody, baseURL: nil)

    }

    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
}