//
//  Date.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/28.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

extension Date {
  var year1900: Date {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.dateFormat = "yyyy"
    return formatter.date(from: "1900") ?? Date()
  }
  
  var tzNow: TimeZone {
    TimeZone.autoupdatingCurrent
  }
  
  func getDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.dateFormat = "yyyyMMddHHmmss"
    return formatter.date(from: date) ?? Date()
  }
  
  func toMessageDate() -> MessageDate {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.dateFormat = "dd,HH,mm,MM,ss,yyyy,e"
    let dArr = formatter.string(from: self).components(separatedBy: ",")
    
    return MessageDate(date: Int(dArr[0]) ?? 0, day: dArr[6].toAndDay(), hours: Int(dArr[1]) ?? 0, minutes: Int(dArr[2]) ?? 0, month: Int(dArr[3]) ?? 0, seconds: Int(dArr[4]) ?? 0, time: Int(self.timeIntervalSince1970), timezoneOffset: self.getTimeZoneDifMin(), year: (Int(dArr[5]) ?? 0) - 1900)
  }
  
  func getTimeZoneDifMin() -> Int {
    guard let defaultZone = TimeZone(secondsFromGMT: 0) else { return 0 }
    let delta = TimeInterval(tzNow.secondsFromGMT(for: self) - defaultZone.secondsFromGMT(for: self))
    return -(Int(delta) / 60)
  }

  func toTimeString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.dateFormat = "HH:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: date)
  }
  
}
