//
//  CGFloat.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
  
  var iOS: CGFloat {
    let width = UIScreen.main.bounds.width
    let ratio = self / 375
    return ceil(width * ratio)
  }

}
