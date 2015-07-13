//
//  RealmNewsViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 27/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import RealmSwift

class RealmNewsViewController: NewsViewController {
    var newsId: Int!

    private let store = DailyRealmStore()

    private var token: NotificationToken?
}

extension RealmNewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            if let news = self.store.newsWithId(self.newsId) {
                self.loadNews(news)
                self.stopIndicator()
            }
        }
    }
}

// Concrete methods
extension RealmNewsViewController {
    override func loadNews() {
        if let news = store.newsWithId(newsId) {
            loadNews(news)
        } else {
            activityIndicator.startAnimating()
            store.news(newsId)
        }
    }

    // TODO: Use protocol
    private func loadNews(news: NewsObject) {
        let css = news.cssURLStrings.map { "<link rel='stylesheet' type='text/css' href='\($0.value)'>" }
        var newsBody = css.reduce(news.body) { $0 + $1 }
        // hide 200px #div.img-place-holder in css
        newsBody.extend("<style>.headline .img-place-holder {\n height: 0px;\n}</style>")

        webView.loadHTMLString(newsBody, baseURL: nil)
    }
}
