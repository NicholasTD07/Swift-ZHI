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
    var newsId: Int?

    private let store = DailyRealmStore()
    private var loadedNewsId: Int?

    private var token: NotificationToken?
}

extension RealmNewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            guard let newsId = self.newsId else { return }

            if let news = self.store.newsWithId(newsId) where newsId != self.loadedNewsId {
                self.loadNews(news)
                self.stopIndicator()
            }
        }
    }
}

// Concrete methods
extension RealmNewsViewController {
    override func loadNews() {
        let newsId = self.newsId ?? 4863580 // TODO: last viewd news

        if let news = store.newsWithId(newsId) {
            loadNews(news)
            loadedNewsId = newsId
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
