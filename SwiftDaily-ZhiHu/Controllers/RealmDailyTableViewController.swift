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

    private func dailyAtDate(date: NSDate) -> DailyObject? {
        return store.dailyAtDate(date)
    }

    private func newsMetaAtIndexPath(indexPath: NSIndexPath) -> NewsMetaObject? {
        let date = dailyDates.dateAtIndex(indexPath.section)
        guard let daily = dailyAtDate(date) else { return nil }

        return daily.news[indexPath.row]
    }

    private func hasNewsWithId(newsId: Int) -> Bool {
        let news = store.newsWithId(newsId)
        return news != nil
    }
}

// MARK: Concrete methods
extension RealmDailyTableViewController {
    override func hasDailyAtIndexPath(indexPath: NSIndexPath) -> Bool {
        let date = dailyDates.dateAtIndex(indexPath.section)
        return store.dailyAtDate(date) != nil
    }

    override func hasNewsMetaAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return newsMetaAtIndexPath(indexPath) != nil
    }

    override func hasNewsAtIndexPath(indexPath: NSIndexPath) -> Bool {
        guard let newsMeta = newsMetaAtIndexPath(indexPath) else { return false }

        return store.newsWithId(newsMeta.newsId) != nil
    }

    override func dateStringAtSection(section: Int) -> String {
        let date = dailyDates.dateAtIndex(section)
        return dateFormatter.stringFromDate(date)
    }

    override func loadDailyAtIndexPath(indexPath: NSIndexPath) {
        store.daily(forDate: dailyDates.dateAtIndex(indexPath.section))
    }

    override func loadLatestDaily() {
        store.updateLatestDaily()
    }

    override func loadNewsAtIndexPath(indexPath: NSIndexPath) {
        guard let newsMeta = self.newsMetaAtIndexPath(indexPath) else { return }

        self.store.news(newsMeta.newsId)
    }

    override func deleteNewsAtIndexPath(indexPath: NSIndexPath) {
        guard let newsMeta = newsMetaAtIndexPath(indexPath) else { return }

        store.deleteNewsWithId(newsMeta.newsId)
    }

    override func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)
        let newsMeta = newsMetaAtIndexPath(indexPath)!

        cell.textLabel?.text = newsMeta.title

        if hasNewsWithId(newsMeta.newsId) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
}

// MARK: UI methods
extension RealmDailyTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            self.dailyDates.endDate = self.store.latestDate
            self.reloadTableViewWhenNotEditing()
        }
    }

    func reloadTableViewWhenNotEditing() {
        if tableView.editing {
            delay(0.1) { self.reloadTableViewWhenNotEditing() }
        } else {
            // HACK: To let the animation for ending editing finish
            //       before table view gets refreshed
            delay(0.3) { self.reloadTableView() }
        }
    }

    func reloadTableView() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNews/Realm" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let newsMeta = newsMetaAtIndexPath(indexPath) else { return }
            guard let nvc = segue.destinationViewController as? UINavigationController else { return }
            guard let vc = nvc.topViewController as? RealmNewsViewController else { return }

            vc.newsId = newsMeta.newsId
            vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            vc.navigationItem.leftItemsSupplementBackButton = true
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
