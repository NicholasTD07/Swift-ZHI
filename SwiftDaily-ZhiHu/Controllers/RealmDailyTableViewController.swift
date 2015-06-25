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
    private let api = DailyAPI()

    private let realm = realmInMemory()
    private var token: NotificationToken?

    private let dailies = realmInMemory().objects(RLMDaily).sorted("date")

    // MARK: UI
    private var firstAppeared = false
    @IBOutlet weak var tableView: UITableView!
}

// MARK: UI methods
extension RealmDailyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        token = realm.addNotificationBlock { (_, _) in
            self.tableView.reloadData()
            print(self.dailies)
            print(self.realm.objects(RLMDaily))
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !firstAppeared {
            api.latestDaily { latestDaily in
                autoreleasepool {
                    let realm = realmInMemory()
                    let daily = RLMDaily()
                    let news = latestDaily.news.map { (newsMeta: NewsMeta) -> RLMNewsMeta in
                        // TODO: Put this into RLMNewsMeta
                        let rlmNews = RLMNewsMeta()
                        rlmNews.newsId = newsMeta.newsId
                        rlmNews.title = newsMeta.title
                        return rlmNews
                    }
                    daily.news.extend(news)
                    daily.date = latestDaily.date
                    daily.dateHash = daily.date.hashValue

                    realm.write {
                        realm.add(daily)
                    }
                }
            }
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
