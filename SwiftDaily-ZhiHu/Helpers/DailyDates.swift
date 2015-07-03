//
//  DailyDates.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 26/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation

class DailyDates {
    let startDate = NSDate.dateAt(year: 2013, month: 05, day: 19)!
    var endDate: NSDate

    private var calendar = NSCalendar.currentCalendar()

    init(endDate: NSDate = NSDate()) {
        self.endDate = endDate
    }

    func dateAtIndex(index: Int) -> NSDate {
        return calendar.dateByAddingUnit(.CalendarUnitDay, value: -index, toDate: endDate, options: nil)!
    }

    func days() -> Int {
        return calendar.components(.CalendarUnitDay, fromDate: startDate, toDate: endDate, options: nil).day + 1
    }

}
