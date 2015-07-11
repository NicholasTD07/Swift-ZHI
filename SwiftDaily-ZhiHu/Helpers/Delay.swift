//
//  Delay.swift
//  Swift-ZHI
//
//  Created by Nicholas Tian on 11/07/2015.
//  Copyright © 2015 nickTD. All rights reserved.
//

import Foundation

func delay(seconds: Double, queue: dispatch_queue_t = dispatch_get_main_queue(), closure: () -> Void) {
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(delay, queue, closure)
}
