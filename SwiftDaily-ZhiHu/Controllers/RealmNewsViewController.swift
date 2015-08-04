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
    private let preferences = UserPreferences()
    private var loadedNewsId: Int?

    private var token: NotificationToken?
}

// MARK: UI methods
extension RealmNewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            if let newsId = self.newsId,
                let news = self.store.newsWithId(newsId) where newsId != self.loadedNewsId {
                self.loadNews(news)
                self.stopIndicator()
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showComments/Realm" {
            if let commentsVC = segue.destinationViewController as? RealmCommentViewController {
                commentsVC.newsId = newsId ?? preferences.lastReadNewsId
            }
        }
    }
}

// Concrete methods
extension RealmNewsViewController {
    override func loadNews() {
        let newsId = self.newsId ?? preferences.lastReadNewsId

        if let news = store.newsWithId(newsId) {
            loadNews(news)
            didLoadNewsInWebViewWithNewsId(newsId)
        } else {
            activityIndicator.startAnimating()
            store.news(newsId)
        }
    }

    private func didLoadNewsInWebViewWithNewsId(newsId: Int) {
        loadedNewsId = newsId
        preferences.lastReadNewsId = newsId
    }

    // TODO: Use protocol
    private func loadNews(news: NewsObject) {
        let css = map(news.cssURLStrings) { "<link rel='stylesheet' type='text/css' href='\($0.value)'>" }
        var newsBody = css.reduce(news.body) { $0 + $1 }
        // hide 200px #div.img-place-holder in css
        newsBody.extend("<style>.headline .img-place-holder {\n height: 0px;\n}</style>")

        webView.loadHTMLString(newsBody, baseURL: nil)
    }
}
