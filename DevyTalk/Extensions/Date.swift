//
//  Date.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/28.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

extension Date {
  func getDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko")
    formatter.dateFormat = "yyyyMMddHHmmss"
    return formatter.date(from: date) ?? Date()
  }
  
  func toMessageDate() -> MessageDate {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko")
    formatter.dateFormat = "dd,HH,mm,MM,ss,yyyy"
    let now = self
    let dArr = formatter.string(from: now).components(separatedBy: ",")
    
    return MessageDate(date: Int(dArr[0]) ?? 0, day: 1, hours: Int(dArr[1]) ?? 0, minutes: Int(dArr[2]) ?? 0, month: Int(dArr[3]) ?? 0, seconds: Int(dArr[4]) ?? 0, time: Int(now.timeIntervalSince1970), timezoneOffset: now.getTimeZoneDif(), year: Int(dArr[5]) ?? 0)
  }
  
  func getTimeZoneDif() -> Int {
    let defaultZone = TimeZone(identifier: "GMT+0")!
    let delta = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self) - defaultZone.secondsFromGMT(for: self))
    return Int(delta)
  }

  func toTimeString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko")
    formatter.dateFormat = "HH:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: date)
  }
  
}
