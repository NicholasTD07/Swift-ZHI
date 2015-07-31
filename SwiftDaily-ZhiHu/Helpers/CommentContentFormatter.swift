//
//  CommentContentFormatter.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 31/07/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SwiftDailyAPI

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
