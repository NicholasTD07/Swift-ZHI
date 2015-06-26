//
//  RealmModels.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 24/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDailyAPI

class NewsMetaObject: Object {
    dynamic var newsId: Int = 0
    dynamic var title: String = ""

    override static func primaryKey() -> String? {
        return "newsId"
    }

    convenience init(newsId: Int, title: String) {
        self.init()
        self.newsId = newsId
        self.title = title
    }

    static func from(newsMeta: NewsMeta) -> NewsMetaObject {
        return NewsMetaObject(newsId: newsMeta.newsId, title: newsMeta.title)
    }
}

class DailyObject: Object {
    dynamic var dateHash: Int = 0
    dynamic var date: NSDate = NSDate()
    let news = List<NewsMetaObject>()

    override static func primaryKey() -> String? {
        return "dateHash"
    }

    convenience init(date: NSDate, news: [NewsMeta]) {
        self.init()
        self.date = date
        self.news.extend(news.map { NewsMetaObject.from($0) })
    }

    static func from(daily: Daily) -> DailyObject {
        // Note: Why not use `convenience init(daily: Daily)`
        // Because it will cause "abort trap 6".

        // TODO: Wait for response from bug report: 21559246
        return DailyObject(date: daily.date, news: daily.news)
    }
}

class StringObject: Object {
    dynamic var value: String = ""

    convenience init(stringValue: String) {
        self.init()
        self.value = stringValue
    }
}

class NewsObject: Object {
    dynamic var newsId: Int = 0
    dynamic var title: String = ""
    dynamic var body: String = ""
    dynamic var cssURLStrings = List<StringObject>()

    override static func primaryKey() -> String? {
        return "newsId"
    }

    convenience init(newsId: Int, title: String, body: String, cssURLStrings: [String]) {
        self.init()
        self.newsId = newsId
        self.title = title
        self.body = body
        self.cssURLStrings.extend(cssURLStrings.map { StringObject(stringValue: $0) })
    }

    static func from(news: News) -> NewsObject {
        return NewsObject(newsId: news.newsId, title: news.title, body: news.body, cssURLStrings: news.cssURLs.map {$0.absoluteString})
    }
}
