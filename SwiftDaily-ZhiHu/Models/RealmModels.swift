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
    public var news = List<NewsMetaObject>()

    override public static func primaryKey() -> String? {
        return "dateHash"
    }

    override public static func indexedProperties() -> [String] {
        return ["dateHash"]
    }

    convenience public init(date: NSDate, news: [NewsMeta]) {
        self.init()
        self.date = date
        self.dateHash = date.hash
        self.news.appendContentsOf(news.map { NewsMetaObject.from($0) })
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
    public var cssURLStrings = List<StringObject>()

    override static public func primaryKey() -> String? {
        return "newsId"
    }

    convenience public init(newsId: Int, title: String, body: String, cssURLStrings: [String]) {
        self.init()
        self.newsId = newsId
        self.title = title
        self.body = body
        self.cssURLStrings.appendContentsOf(cssURLStrings.map { StringObject(stringValue: $0) })
    }

    static public func from(news: News) -> NewsObject {
        return NewsObject(newsId: news.newsId, title: news.title, body: news.body, cssURLStrings: news.cssURLs.map {$0.absoluteString})
    }
}

public class ReplyToCommentObject: Object {
    dynamic public var authorName: String = ""
    dynamic public var content: String = ""
    dynamic public var _primaryKey: Int = 0


    override static public func primaryKey() -> String? {
        return "_primaryKey"
    }

    public func setAuthorName(authorName: String, content: String) {
        self.authorName = authorName
        self.content = content

        _primaryKey = "\(authorName)\(content)".hash
    }

    static public func from(replyToComment: ReplyToComment?) -> Self? {
        // TODO: guard
        if let replyToComment = replyToComment {
            let object = self.init()
            object.setAuthorName(replyToComment.authorName, content: replyToComment.content)
            return object
        } else {
            return nil
        }
    }
}

public class CommentObject: Object {
    // MARK: vars exist only in Realm
    dynamic public var newsId: Int = 0
    dynamic public var isShortComment: Bool = true
    // MARK: vars in JSON
    dynamic public var commentId: Int = 0
    dynamic public var authorName: String = ""
    dynamic public var content: String = ""
    dynamic public var likes: Int = 0
    dynamic public var repliedAt: NSDate = NSDate()
    dynamic public var avatarURLString: String = ""
    dynamic public var replyToComment: ReplyToCommentObject?

    public var avatarURL: NSURL {
        get { return NSURL(string: avatarURLString)! }
    }

    override static public func primaryKey() -> String? {
        return "commentId"
    }

    public func setCommentId(commentId: Int , authorName: String , content: String , likes: Int , repliedAt: NSDate , avatarURL: NSURL , replyToComment: ReplyToComment?, newsId: Int, isShortComment: Bool) {
        self.newsId = newsId
        self.isShortComment = isShortComment

        self.commentId = commentId
        self.authorName = authorName
        self.content = content
        self.likes = likes
        self.repliedAt = repliedAt
        self.avatarURLString = avatarURL.absoluteString
        self.replyToComment = ReplyToCommentObject.from(replyToComment)
    }

    // Default to short comment.
    static public func from(comment: Comment, forNewsId newsId: Int, isShortComment: Bool) -> Self {
        let object = self.init()

        object.setCommentId(comment.commentId, authorName: comment.authorName , content: comment.content , likes: comment.likes , repliedAt: comment.repliedAt, avatarURL: comment.avatarURL, replyToComment: comment.replyToComment, newsId: newsId, isShortComment: isShortComment)

        return object
    }
}
