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

    public func dailyAtDate(date: NSDate) -> DailyObject? {
        let results = realm.objects(DailyObject).filter("dateHash == \(date.hash)")
        return results.first
    }

    public func newsWithId(newsId: Int) -> NewsObject? {
        let results = realm.objects(NewsObject).filter("newsId == \(newsId)")
        return results.first
    }

    public func deleteNewsWithId(newsId: Int, inRealm realm: Realm = defaultRealm()) {
        guard let news = newsWithId(newsId) else { return }

        realm.write { realm.delete(news) }
    }

    public func updateLatestDaily() {
        dailyAPI.latestDaily { latestDaily in
            self.latestDaily = latestDaily
            self.addDaily(Daily(latestDaily))
        }
    }

    public func daily(forDate date: NSDate) {
        dailyAPI.daily(forDate: date) { self.addDaily($0) }
    }

    private func addDaily(daily: Daily, toRealm realm: Realm = defaultRealm()) {
        addObject(DailyObject.from(daily))
    }

    private func addObject(object: Object, toRealm realm: Realm = defaultRealm()) {
        realm.write { realm.add(object, update: true) }
    }

    public func news(newsId: Int) {
        dailyAPI.news(newsId) { self.addObject(NewsObject.from($0)) }
    }
}
