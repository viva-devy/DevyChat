//
//  UIDevice.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

extension UIDevice {
  var hasNotch: Bool {
    let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    return bottom > 0
  }
}
