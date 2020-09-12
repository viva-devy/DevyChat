//
//  Int.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import UIKit

public extension IntegerLiteralType {
  var i: CGFloat {
    return CGFloat(self).iOS
  }
  
  func toCurrentTimeZoneDateWithOffset(Interval time: Int) -> Date {
    guard let targetTZ = TimeZone(secondsFromGMT: -(self * 60)) else { return Date() }
    let now = Date(timeIntervalSince1970: TimeInterval(time))
    let myTZ = TimeZone.autoupdatingCurrent
    let delta = TimeInterval(myTZ.secondsFromGMT(for: now) - targetTZ.secondsFromGMT(for: now))
    
    return now.addingTimeInterval(delta)
  }
}

extension Int {
  func fillZero() -> String {
    let str = String(self)
    guard str.count == 1 else { return str }
    return "0" + str
  }
}
