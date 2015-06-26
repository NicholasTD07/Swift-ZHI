//
//  RealmDailyTableViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 24/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDailyAPI

class RealmDailyTableViewController: DailyTableViewController {
    private let store = DailyRealmStore()
    private let dailyDates = DailyDates()

    private var token: NotificationToken?

    private let dailies = defaultRealm().objects(DailyObject).sorted("date")

    private func dailyAtDate(date: NSDate) -> DailyObject? {
        let results = dailies.filter("dateHash == \(date.hash)")
        return results.first
    }

    private func newsMetaAtIndexPath(indexPath: NSIndexPath) -> NewsMetaObject? {
        let date = dailyDates.dateAtIndex(indexPath.section)
        guard let daily = dailyAtDate(date) else { return nil }

        return daily.news[indexPath.row]
    }

    override func hasNewsMetaAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return newsMetaAtIndexPath(indexPath) != nil
    }

    override func dateStringAtSection(section: Int) -> String {
        let date = dailyDates.dateAtIndex(section)
        return dateFormatter.stringFromDate(date)
    }

    override func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)
        let newsMeta = newsMetaAtIndexPath(indexPath)!

        cell.textLabel?.text = newsMeta.title

        return cell
    }
}


// MARK: UI methods
extension RealmDailyTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            self.dailyDates.endDate = self.store.latestDate
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !firstAppeared {
            store.updateLatestDaily()
        }
    }
}

// MARK: Data Source
extension RealmDailyTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dailyDates.days()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dailyDates.dateAtIndex(section)
        guard let daily = dailyAtDate(date) else { return 1 }

        return daily.news.count
    }

}
