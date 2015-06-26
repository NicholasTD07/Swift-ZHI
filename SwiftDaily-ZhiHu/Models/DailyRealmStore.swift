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
        realm.write { realm.add(object) }
    }

    public func news(newsId: Int) {
        dailyAPI.news(newsId) { self.addObject(NewsObject.from($0)) }
    }
}
