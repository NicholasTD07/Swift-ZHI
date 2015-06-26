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

class RealmDailyTableViewController: UIViewController {
    private let store = DailyRealmStore()

    private var token: NotificationToken?

    private let dailies = defaultRealm().objects(DailyObject).sorted("date")

    // MARK: UI
    private var firstAppeared = false
    @IBOutlet weak var tableView: UITableView!
}

// MARK: UI methods
extension RealmDailyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        token = defaultRealm().addNotificationBlock { (_, _) in
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
        return dailies.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailies[section].news.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsMetaCell", forIndexPath: indexPath)
        let newsMeta = dailies[indexPath.section].news[indexPath.row]

        cell.textLabel?.text = newsMeta.title

        return cell
    }
}

extension RealmDailyTableViewController: UITableViewDelegate {

}
