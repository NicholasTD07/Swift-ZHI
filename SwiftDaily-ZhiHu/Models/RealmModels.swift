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

public class NewsMetaObject: Object {
    dynamic public var newsId: Int = 0
    dynamic public var title: String = ""

    override static public func primaryKey() -> String? {
        return "newsId"
    }

    convenience public init(newsId: Int, title: String) {
        self.init()
        self.newsId = newsId
        self.title = title
    }

    static public func from(newsMeta: NewsMeta) -> NewsMetaObject {
        return NewsMetaObject(newsId: newsMeta.newsId, title: newsMeta.title)
    }
}

public class DailyObject: Object {
    dynamic public var dateHash: Int = 0
    dynamic public var date: NSDate = NSDate()
    public let news = List<NewsMetaObject>()

    override public static func primaryKey() -> String? {
        return "dateHash"
    }

    override public static func indexedProperties() -> [String] {
        return ["date", "dateHash"]
    }

    convenience public init(date: NSDate, news: [NewsMeta]) {
        self.init()
        self.date = date
        self.dateHash = date.hash
        self.news.extend(news.map { NewsMetaObject.from($0) })
    }

    static public func from(daily: Daily) -> DailyObject {
        // Note: Why not use `convenience init(daily: Daily)`
        // Because it will cause "abort trap 6".

        // TODO: Wait for response from bug report: 21559246
        return DailyObject(date: daily.date, news: daily.news)
    }
}

public class StringObject: Object {
    dynamic public var value: String = ""

    convenience public init(stringValue: String) {
        self.init()
        self.value = stringValue
    }
}

public class NewsObject: Object {
    dynamic public var newsId: Int = 0
    dynamic public var title: String = ""
    dynamic public var body: String = ""
    dynamic public var cssURLStrings = List<StringObject>()

    override static public func primaryKey() -> String? {
        return "newsId"
    }

    convenience public init(newsId: Int, title: String, body: String, cssURLStrings: [String]) {
        self.init()
        self.newsId = newsId
        self.title = title
        self.body = body
        self.cssURLStrings.extend(cssURLStrings.map { StringObject(stringValue: $0) })
    }

    static public func from(news: News) -> NewsObject {
        return NewsObject(newsId: news.newsId, title: news.title, body: news.body, cssURLStrings: news.cssURLs.map {$0.absoluteString!})
    }
}
