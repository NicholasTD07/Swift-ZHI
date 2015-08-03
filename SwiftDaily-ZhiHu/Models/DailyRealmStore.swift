//
//  DailyRealmStore.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 25/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDailyAPI

public class DailyRealmStore {
    public var latestDaily: LatestDaily?
    public var latestDate: NSDate {
        return latestDaily?.date ?? NSDate()
    }

    let dailyAPI: DailyAPI
    let realm = defaultRealm()

    public init(completionQueue: dispatch_queue_t? = nil)
    {
        dailyAPI = DailyAPI(completionQueue: completionQueue)
    }
}

extension DailyRealmStore {
    // MARK: Insertion by calling to `DailyAPI`
    public func updateLatestDaily() {
        dailyAPI.latestDaily { latestDaily in
            self.latestDaily = latestDaily
            self.addDaily(Daily(latestDaily))
        }
    }

    public func daily(forDate date: NSDate) {
        dailyAPI.daily(forDate: date) { self.addDaily($0) }
    }

    public func news(newsId: Int) {
        dailyAPI.news(newsId) { self.addObject(NewsObject.from($0)) }
    }

    public func longComments(forNewsId newsId: Int) {
        dailyAPI.longComments(newsId) {
            $0.comments.map {
                self.addObject(CommentObject.from($0, forNewsId: newsId, isShortComment: false))
            }
        }
    }

    public func shortComments(forNewsId newsId: Int) {
        dailyAPI.shortComments(newsId) {
            // NOTE: Wow, two different $0 in the same line.
            //       I am a bit worried the compiler may get confused.
            $0.comments.map {
                self.addObject(CommentObject.from($0, forNewsId: newsId, isShortComment: true))
            }
        }
    }

    public func shortComments(forNewsId newsId: Int, beforeCommentId commentId: Int) {
        dailyAPI.shortComments(newsId, beforeCommentId: commentId) {
            // NOTE: BAD CODE SMELL - Copy and paste from `shortComments(forNewsId:)`
            $0.comments.map {
                self.addObject(CommentObject.from($0, forNewsId: newsId, isShortComment: true))
            }
        }
    }

    // MARK: Deletion
    public func deleteNewsWithId(newsId: Int, inRealm realm: Realm = defaultRealm()) {
        if let news = newsWithId(newsId) {
            realm.write { realm.delete(news) }
        }
    }
}

// MARK: Getters
extension DailyRealmStore {
    public func dailyAtDate(date: NSDate) -> DailyObject? {
        let results = realm.objects(DailyObject).filter("dateHash == \(date.hash)")
        return results.first
    }

    public func newsWithId(newsId: Int) -> NewsObject? {
        let results = realm.objects(NewsObject).filter("newsId == \(newsId)")
        return results.first
    }
}

// MARK: Private methods
extension DailyRealmStore {
    private func addDaily(daily: Daily, toRealm realm: Realm = defaultRealm()) {
        addObject(DailyObject.from(daily))
    }

    private func addObject(object: Object, toRealm realm: Realm = defaultRealm()) {
        realm.write { realm.add(object, update: true) }
    }
}
