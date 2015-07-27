//
//  RealmCommentViewController.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 27/07/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit

class RealmCommentViewController: UIViewController {
}

// MARK: Data Source
extension RealmCommentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
