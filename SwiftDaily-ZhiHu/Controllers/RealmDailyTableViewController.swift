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

class RealmDailyTableViewController: HidesHairLineUnderNavBarViewController {
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

    // MARK: UI
    private var firstAppeared = false
    @IBOutlet weak var tableView: UITableView!

    // TODO: clean up
    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
        }()
    private let refreshControl: UIRefreshControl = UIRefreshControl()

}

// MARK: UI methods
extension RealmDailyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
            self.dailyDates.endDate = self.store.latestDate
            self.tableView.reloadData()
        }

        setupUi()
    }

    // TODO: clean up
    private func setupUi() {
        tableView.registerNib(UINib(nibName: "DailySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DailySectionHeaderView")

        refreshControl.addTarget(self, action: "refreshLatestDaily", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let newsMeta = newsMetaAtIndexPath(indexPath) else {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }

        // TODO: configueCell
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)

        cell.textLabel?.text = newsMeta.title

        return cell
    }

    // TODO: clean up
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("DailySectionHeaderView") as? DailySectionHeaderView else { return nil }

        header.backgroundView = {
            let view = UIView(frame: header.bounds)
            // HACK: To put color in Storyboard, not in code
            view.backgroundColor = header.titleLabel.highlightedTextColor
            return view
            }()
        header.titleLabel.text = dateFormatter.stringFromDate(dailyDates.dateAtIndex(section))

        return header
    }
}

extension RealmDailyTableViewController: UITableViewDelegate {

}
