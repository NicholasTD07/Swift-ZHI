//
//  RealmCommentViewController.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 27/07/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI
import Haneke

// TODO: Save comments in Realm
class RealmCommentViewController: UIViewController {
    var newsId: Int?

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    private let api = DailyAPI(completionQueue: dispatch_get_main_queue())
    private var comments: [Comment] = []
    private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        return formatter
        }()
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

        tableView.registerNib(UINib(nibName: "CommentSectionHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CommentSectionHeaderView")
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
        return comments.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell/TextOnly") as! UITableViewCell
        let comment = commentInSection(indexPath.section)

        var content = comment.content
        if let replyTo = comment.replyToComment {
            content = "\n\n".join(["\(replyTo.authorName): \"\(replyTo.content)\"", content])
        }

        cell.textLabel?.text = content
        cell.textLabel?.sizeToFit()
        cell.sizeToFit()
        return cell
    }

    func commentInSection(section: Int) -> Comment {
        return comments[section]
    }
}

extension RealmCommentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CommentSectionHeaderView") as? CommentSectionHeaderView {
            let comment = commentInSection(section)

            // FIX/HACK: cant create a header view with `contentView` like the one in the xib for UITableViewCell
            header.backgroundView = {
                let view = UIView(frame: header.bounds)
                view.backgroundColor = tableView.backgroundColor
                view.alpha = 0.95
                return view
            }()

            header.usernameLabel.text = comment.authorName
            header.repliedAtLabel.text = dateFormatter.stringFromDate(comment.repliedAt)

            if let url = header.avatarURL where url != comment.avatarURL {
                header.avatarImageView.image = nil
                header.avatarImageView.hnk_cancelSetImage()
            }

            header.avatarImageView.hnk_setImageFromURL(comment.avatarURL)

            return header
        } else {
            return nil
        }
    }
}
