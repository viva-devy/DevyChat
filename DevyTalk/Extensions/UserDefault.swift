//
//  UserDefault.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

extension UserDefaults {
  // true -> saved (non visible)
  static func getTipState(id: String) -> Bool {
    guard let dict = self.standard.dictionary(forKey: "tipState") else { return false }
    guard let state = dict[id] as? Bool else { return false }
    return state
  }
  
  static func setTipState(id: String) {
    if var dict = self.standard.dictionary(forKey: "tipState") {
      dict.updateValue(true, forKey: id)
      self.standard.setValue(dict, forKey: "tipState")
    } else {
      let tempDict = [id: true]
      self.standard.setValue(tempDict, forKey: "tipState")
    }
  }
}
