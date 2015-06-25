//
//  RealmHelpers.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 25/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation
import RealmSwift

func realmInMemory() -> Realm {
    return Realm(inMemoryIdentifier: "DailyTestGround")
}
