//
//  DailyNewsTableViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 29/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI

// TODO: think about all the `self`s in closures

class DailyTableViewController: UIViewController {
    // MARK: Store
    private let store = DailyInMemoryStore()

    private func loadLatestDaily() {
        store.latestDaily { latestDaily in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func dailyAtSection(section: Int) -> Daily? {
        return store.dailies[section]
    }

    private func newsMetaAtIndexPath(indexPath: NSIndexPath) -> NewsMeta? {
        guard let daily = dailyAtSection(indexPath.section) else { return nil }

        return daily.news[indexPath.row]
    }

    // MARK: UI vars
    private var firstAppeared = false
    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
    }()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshControl: UIRefreshControl!
}

// MARK: UI methods
extension DailyTableViewController {
    private func loadDailyIntoTableView(daily: Daily) {
        let tableView = self.tableView
        let sectionIndex = store.dailies.indexAtDate(daily.date)
        tableView.beginUpdates()
        tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation:
            UITableViewRowAnimation.Automatic)
        tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !firstAppeared {
            beginRefreshing()
            firstAppeared = true
            loadLatestDaily()
        }

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "showNews" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let newsMeta = newsMetaAtIndexPath(indexPath) else { return }

        let newsVC = segue.destinationViewController as! NewsViewController
        newsVC.store = store
        newsVC.newsId = newsMeta.newsId
    }

    @IBAction func refreshLatestDaily() {
        loadLatestDaily()
    }

    private func beginRefreshing() {
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
    }

}

// MARK: Data Source
extension DailyTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return store.dailies.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyAtSection(section)?.news.count ?? 1
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension DailyTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let newsMeta = newsMetaAtIndexPath(indexPath) else {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)

        cell.textLabel?.text = newsMeta.title

        if let _ = store.news[newsMeta.newsId] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save") { (_, indexPath) in
            self.tableView.setEditing(false, animated: true)

            guard let newsMeta = self.newsMetaAtIndexPath(indexPath) else { return }

            // TODO: should notify user successful fetching and decoding
            self.store.news(newsMeta.newsId) { (news) in
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        save.backgroundColor = UIColor(hue: 0.353, saturation: 0.635, brightness: 0.765, alpha: 1)
        return [save]
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let _ = cell as? LoadingCell else { return }

        let date = store.dailies.dateIndexAtIndex(indexPath.section).date

        store.daily(forDate: date) { self.loadDailyIntoTableView($0) }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.stringFromDate(store.dailies.dateIndexAtIndex(section).date)
    }
}
