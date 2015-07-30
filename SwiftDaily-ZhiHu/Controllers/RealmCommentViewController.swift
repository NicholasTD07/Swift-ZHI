//
//  RealmCommentViewController.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 27/07/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI

// TODO: Save comments in Realm
class RealmCommentViewController: UIViewController {
    var newsId: Int?

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    private let api = DailyAPI(completionQueue: dispatch_get_main_queue())
    private var comments: [Comment] = []
}

// MARK:
extension RealmCommentViewController {
    func loadNewsComments() {
        if let newsId = newsId { // TODO: Swift 2.0, guard
            let handler: (Comments) -> Void = { self.loadNewsComments($0.comments) }

            beginRefreshing()

            api.comments(newsId,
                shortCommentsHandler: handler,
                longCommentsHandler: handler
            )
        }
    }

    func loadNewsComments(comments: [Comment]) {
        self.comments.extend(comments)
        self.comments.sort { $0.repliedAt < $1.repliedAt }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: UI methods
extension RealmCommentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        refreshControl.addTarget(self, action: "loadNewsComments", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    func beginRefreshing() {
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadNewsComments()
    }
}

// MARK: Data Source
extension RealmCommentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell/TextOnly") as! UITableViewCell
        let comment = commentAtIndexPath(indexPath)

        var content = ": ".join([comment.authorName, comment.content])
        if let replyTo = comment.replyToComment {
            content = "\n\n".join(["\(replyTo.authorName): \"\(replyTo.content)\"", content])
        }

        cell.textLabel?.text = content
        cell.textLabel?.sizeToFit()
        cell.sizeToFit()
        return cell
    }

    func commentAtIndexPath(indexPath: NSIndexPath) -> Comment {
        return comments[indexPath.row]
    }
}

extension RealmCommentViewController: UITableViewDelegate {
}
