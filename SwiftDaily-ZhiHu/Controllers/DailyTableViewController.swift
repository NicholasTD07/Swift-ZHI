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
    private var dailyNewsMeta: [NewsMeta] {
        get {
            return [Daily](store.dailies.values).flatMap { $0.news }
        }
    }

    private func loadLatestDaily() {
        store.latestDaily { latestDaily in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func newsMetaAtIndexPath(indexPath: NSIndexPath) -> NewsMeta {
        return dailyNewsMeta[indexPath.row]
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

        let newsVC = segue.destinationViewController as! NewsViewController
        newsVC.store = store
        newsVC.newsId = newsMetaAtIndexPath(indexPath).newsId
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

// MARK: Data Source and Delegate
extension DailyTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyNewsMeta.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)

        let newsMeta = newsMetaAtIndexPath(indexPath)
        cell.textLabel?.text = newsMeta.title

        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
