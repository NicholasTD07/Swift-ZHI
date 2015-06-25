//
//  RealmModels.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 24/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation
import RealmSwift

class RLMNewsMeta: Object {
    dynamic var newsId: Int = 0
    dynamic var title: String = ""

    override static func primaryKey() -> String? {
        return "newsId"
    }
}

class RLMDaily: Object {
    dynamic var dateHash: Int = 0
    dynamic var date: NSDate = NSDate()
    let news = List<RLMNewsMeta>()

    override static func primaryKey() -> String? {
        return "dateHash"
    }
}
