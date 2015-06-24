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
    private let realm = try! Realm()
    private let api = DailyAPI()
//    var token: NotificationToken?

    // MARK: UI
    private var firstAppeared = false
    @IBOutlet weak var tableView: UITableView!
}

// MARK: UI methods
extension RealmDailyTableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let token = realm.addNotificationBlock { (n, m) in self.tableView.reloadData() }

        if !firstAppeared {
            api.latestDaily { latestDaily in
                autoreleasepool {
                    let realm = try! Realm()
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

                    print(daily)

                    realm.write {
                        realm.add(daily)
                    }
                }
            }
        }
    }
}

// MARK: Data Source
//extension RealmDailyTableViewController: UITableViewDataSource {
//
//}

extension RealmDailyTableViewController: UITableViewDelegate {

}
