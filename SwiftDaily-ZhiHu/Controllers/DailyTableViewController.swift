//
//  DailyTableViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 26/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class DailyTableViewController: HideNavBarViewController {
    // MARK: UI
    @IBOutlet weak var tableView: UITableView!
    let refreshControl: UIRefreshControl = UIRefreshControl()

    var firstAppeared = false
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
        }()
}

// MARK: Abstract methods
extension DailyTableViewController {
    func hasDailyAtIndexPath(indexPath: NSIndexPath) -> Bool {
        fatalError()
    }

    func hasNewsMetaAtIndexPath(indexPath: NSIndexPath) -> Bool {
        fatalError()
    }

    func dateStringAtSection(section: Int) -> String {
        fatalError()
    }

    func loadLatestDaily() {
    }

    func loadDailyAtIndexPath(indexPath: NSIndexPath) {
    }

    func loadNewsAtIndexPath(indexPath: NSIndexPath) {
    }

    func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        fatalError()
    }
}

// MARK: UI methods
extension DailyTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
    }

    func setupUi() {
        refreshControl.addTarget(self, action: "refreshLatestDaily", forControlEvents: UIControlEvents.ValueChanged)

        tableView.addSubview(refreshControl)
        tableView.registerNib(UINib(nibName: "DailySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DailySectionHeaderView")
    }


    @IBAction func refreshLatestDaily() {
        loadLatestDaily()
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

    func beginRefreshing() {
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
    }
}

// MARK: Data Source
extension DailyTableViewController {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard hasNewsMetaAtIndexPath(indexPath) else {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }

        return cellAtIndexPath(indexPath)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

// MARK: Delegate
extension DailyTableViewController {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("DailySectionHeaderView") as? DailySectionHeaderView else { return nil }

        header.backgroundView = {
            let view = UIView(frame: header.bounds)
            // HACK: To put color in Storyboard, not in code
            view.backgroundColor = header.titleLabel.highlightedTextColor
            return view
            }()

        header.titleLabel.text = self.dateStringAtSection(section)

        return header
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let _ = cell as? LoadingCell else { return }

        if !hasDailyAtIndexPath(indexPath) {
            loadDailyAtIndexPath(indexPath)
        }
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save") { (_, indexPath) in
            self.tableView.setEditing(false, animated: true)
            self.loadNewsAtIndexPath(indexPath)
        }
        save.backgroundColor = UIColor(hue: 0.353, saturation: 0.635, brightness: 0.765, alpha: 1)
        return [save]
    }
}
