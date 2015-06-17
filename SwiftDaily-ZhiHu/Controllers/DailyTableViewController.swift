//
//  DailyNewsTableViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 29/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI

class DailyTableViewController: UIViewController {
    // MARK: Store
    private let store = DailyInMemoryStore()

    private func loadLatestDaily() {
        store.latestDaily { latestDaily in
            self.refreshControl?.endRefreshing()
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
    var firstAppeared = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshControl: UIRefreshControl!
}

// MARK: UI methods
extension DailyTableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !firstAppeared {
            beginRefreshing()
            firstAppeared = true
        }

        loadLatestDaily()
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
        guard let refreshControl = refreshControl else { return }

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
}

extension DailyTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let newsMeta = newsMetaAtIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)
            cell.textLabel?.text = newsMeta.title
            return cell
        } else {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return store.dailies.endIndex.advancedBy(-section + -1).date.toString(format: "yyyy MM dd")
    }
}
