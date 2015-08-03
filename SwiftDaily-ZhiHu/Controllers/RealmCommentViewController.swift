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
import RealmSwift

class RealmCommentViewController: UIViewController {
    var newsId: Int!

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    private var store = DailyRealmStore()
    private var token: NotificationToken?

    private var comments: Results<CommentObject> {
        get {
            return store.commentsForNewsId(newsId).sorted("repliedAt", ascending: false)
        }
    }

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
            beginRefreshing()
            store.shortComments(forNewsId: newsId)
            store.longComments(forNewsId: newsId)
        }
    }

    func commentInSection(section: Int) -> CommentObject {
        return comments[section]
    }
}

// MARK: DidScrollToEnd
extension RealmCommentViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let didComeToTheEnd = scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        if let lastShortComment = store.shortCommentsForNewsId(newsId).sorted("commentId", ascending: true).first where didComeToTheEnd {
            // TODO: There could be a test for whether this is the correct way to get the last comment or not
            store.shortComments(forNewsId: newsId, beforeCommentId: lastShortComment.commentId)
        }
    }
}

// MARK: UI methods
extension RealmCommentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        setupRealm()
    }

    private func setupRealm() {
        token = defaultRealm().addNotificationBlock { (_, _) in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    private func setupUi() {
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

        cell.textLabel?.attributedText = CommentContentFormatter(comment: comment).attributedContent
        cell.textLabel?.sizeToFit()
        cell.sizeToFit()

        return cell
    }
}

extension RealmCommentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CommentSectionHeaderView") as? CommentSectionHeaderView {
            // FIX/HACK: cant create a header view with `contentView` like the one in the xib for UITableViewCell
            header.backgroundView = {
                let view = UIView(frame: header.bounds)
                view.backgroundColor = tableView.backgroundColor
                view.alpha = 0.96
                return view
            }()

            let comment = commentInSection(section)

            header.usernameLabel.text = comment.authorName
            header.repliedAtLabel.text = dateFormatter.stringFromDate(comment.repliedAt)

            if let url = header.avatarURL where url != comment.avatarURL {
                header.avatarImageView.hnk_cancelSetImage()
                header.avatarImageView.image = nil
            }

            header.avatarImageView.hnk_setImageFromURL(comment.avatarURL)

            return header
        } else {
            return nil
        }
    }
}
