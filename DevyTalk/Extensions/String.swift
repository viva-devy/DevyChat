//
//  String.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/10.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

extension String {
  func toDate() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.dateFormat = "yyyyMMdd"
    let date = formatter.date(from: self) ?? Date()
    formatter.dateFormat = "eee"
    return formatter.string(from: date)
  }
  
  func toAndDay() -> Int {
    switch self {
      case "1": // 월
      return 1
      case "2": // 화
      return 2
      case "3": // 수
      return 3
      case "4": // 목
      return 4
      case "5": // 금
      return 5
      case "6": // 토
      return 6
      case "7": // 일
      return 0
      default:
      return 0
    }
  }
}
