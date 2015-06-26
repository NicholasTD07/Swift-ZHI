//
//  DailyTableViewController.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 26/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import UIKit

class DailyTableViewController: HidesHairLineUnderNavBarViewController {

    func hasNewsMetaAtIndexPath(indexPath: NSIndexPath) -> Bool {
        fatalError()
    }

    func dateStringAtSection(section: Int) -> String {
        fatalError()
    }

    func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        fatalError()
    }

    // MARK: UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    let refreshControl: UIRefreshControl = UIRefreshControl()

    var firstAppeared = false
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
        }()

    deinit {
        stopFollowingScrollView()
    }
}

// MARK: UI methods
extension DailyTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
    }

    func setupUi() {
        tableView.registerNib(UINib(nibName: "DailySectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DailySectionHeaderView")

        refreshControl.addTarget(self, action: "refreshLatestDaily", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        followScrollView(tableView, usingTopConstraint: tableViewTopConstraint)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        showNavBarAnimated(false)
    }
}

extension DailyTableViewController {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard hasNewsMetaAtIndexPath(indexPath) else {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }

        return cellAtIndexPath(indexPath)
    }

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
}
