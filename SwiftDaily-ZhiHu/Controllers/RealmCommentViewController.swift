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
    private let replyString = NSLocalizedString("Reply", comment: "Reply string in CommentView")
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

        cell.textLabel?.attributedText = CommentContentFormatter(comment: comment).attributedContent
        cell.textLabel?.sizeToFit()
        cell.sizeToFit()
        return cell
    }

    struct CommentContentFormatter {
        let comment: Comment
        let replyToComment: ReplyToComment?
        static let replyString = NSLocalizedString("Reply", comment: "Reply string in CommentView")
        static let newlinesBetweenCommentAndReply = "\n\n"

        init(comment: Comment) {
            self.comment = comment
            self.replyToComment = comment.replyToComment
        }

        var attributedContent: NSAttributedString {
            get {
                let attributedContent = NSMutableAttributedString(string: content)
                let systemFontSize = UIFont.systemFontSize()

                attributedContent.addAttributes(
                    [
                        NSForegroundColorAttributeName: UIColor.grayColor(),
                        NSFontAttributeName: UIFont.systemFontOfSize(systemFontSize - 1)
                    ],
                    range: rangeOfReplyContentWithNewlines
                )
                attributedContent.addAttributes(
                    [NSFontAttributeName: UIFont.boldSystemFontOfSize(systemFontSize)],
                    range: rangeOfReplyAuthor
                )

                return attributedContent
            }
        }

        var rangeOfReplyAuthor: NSRange {
            get { return (content as NSString).rangeOfString(replyAuthorString) }
        }

        var rangeOfReplyContentWithNewlines: NSRange {
            get { return (content as NSString).rangeOfString(replyContentString) }
        }

        var content: String {
            get {
                return replyContentStringWithNewlines + commentContentString
            }
        }

        var commentContentString: String { get { return comment.content } }

        var replyContentStringWithNewlines: String {
            get {
                if replyToComment == nil {
                    return ""
                }

                return CommentContentFormatter.replyString + " " + replyContentString + CommentContentFormatter.newlinesBetweenCommentAndReply
            }
        }

        var replyContentString: String { get { return replyAuthorString + "\n\n" + replyCommentString} }

        var replyCommentString: String { get { return replyToComment?.content ?? "" } }

        var replyAuthorString: String { get { return replyToComment?.authorName ?? "" } }
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
                view.alpha = 0.96
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
