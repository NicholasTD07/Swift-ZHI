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
    let realm = defautRealm()
    private static let dailyStartDate = NSDate.dateAt(year: 2013, month: 05, day: 19)!

    public init(completionQueue: dispatch_queue_t? = nil)
    {
        dailyAPI = DailyAPI(completionQueue: completionQueue)
    }

    public func latestDaily(_: Int) {
        dailyAPI.latestDaily { latestDaily in
            let realm = realmInMemory()
            
        }
    }
}
