//
//  RealmHelpers.swift
//  SwiftDaily-ZhiHu
//
//  Created by Nicholas Tian on 25/06/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation
import RealmSwift

func defautRealm() -> Realm {
    // TODO: Until next release, use in memroy realm
    // NOTE: So there's no need to migrate XD until a stable model
    return Realm(inMemoryIdentifier: "DailyTestGround")
}
