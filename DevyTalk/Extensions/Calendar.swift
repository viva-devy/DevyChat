//
//  Calendar.swift
//  DevyTalk
//
//  Created by hyeoktae kwon on 2020/09/11.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

extension Calendar {
  func dateBySetting(timeZone: TimeZone, of date: Date) -> Date? {
      var components = dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
      components.timeZone = timeZone
      return self.date(from: components)
  }

  // case 2
  func dateBySettingTimeFrom(timeZone: TimeZone, of date: Date) -> Date? {
      var components = dateComponents(in: timeZone, from: date)
      components.timeZone = self.timeZone
      return self.date(from: components)
  }
}
