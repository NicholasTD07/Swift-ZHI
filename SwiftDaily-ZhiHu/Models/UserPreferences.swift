//
//  UserPreferences.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 14/07/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation

class UserPreferences {
    let userDefaults: NSUserDefaults

    static let userDefaultsDictionary = [
        PreferenceKeys.LastReadNewsId.rawValue: 4862871
        // Title: 高大上的苹果店，装修究竟好在哪儿？
        // Web page URL: http://daily.zhihu.com/story/4862871
    ]

    init(userDefaults: NSUserDefaults = NSUserDefaults()) {
        self.userDefaults = userDefaults
    }

    class func registerDefaults() {
        NSUserDefaults().registerDefaults(userDefaultsDictionary)
    }

    enum PreferenceKeys: String {
        case LastReadNewsId = "lastReadNewsId"
    }

    var lastReadNewsId: Int {
        get {
            return userDefaults.integerForKey(PreferenceKeys.LastReadNewsId.rawValue)
        }

        set {
            userDefaults.setInteger(newValue, forKey: PreferenceKeys.LastReadNewsId.rawValue)
        }
    }
}
