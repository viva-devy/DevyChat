//
//  UIColor.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import UIKit

enum AssetsColor {
  // AppColor Green
  case aBk        // 404041
  case aPk        // ed4097
  case lgr2       // f2f2f2
  case dgr1       // 828282
  case aOg        // e8715d  darkPeach
  case gr1        // b4b5b5
  case gr2        // 939597
  case lgr1       // f7f7f7f7
  case lgr3       // e6e7e8
  case lgr4       // dcdcdc
  case aPp        // 935aa8
  case whiteTwo   // ffffff
  case aLpg       // F3E9ED
  case dgr4       // 5c5c5c
  case dgr3       // 58585b
  case dgr2       // 707070
  case amt        // 3DBFB8
  case aPpk       // DB90B6
  case aDpk       // B65B89
  case aLpk       // F88BC1
  case aYw        // f1ab4a
  case vermillion // 없음
  case aBl        // 1B75BB
  case aBl2       // 19A3CE
  case peachyPink // 없음
  case dusk       // 없음
  case paleGrey   // 없음
  case aVp        // D65BB9
  case pastelRed  // 없음
  case blueyGreen // 없음
  case blueyGreyThree   // 없음
  case aVb        // 938AD7
  case darkSkyBlue      // 없음
  case dark       // 없음
  case darkTwo    // 없음
  case darkThree  // 없음
  case manilla    // 없음
  case darkPeriwinkle   // 없음
  case brownGrayTwo
  case perryWinkle
}

extension UIColor {
  static func appColor(_ colorName: AssetsColor, alpha: CGFloat? = nil) -> UIColor {
    switch colorName {
    case .aPpk:
      return UIColor(red: 219.0 / 255.0, green: 144.0 / 255.0, blue: 182.0 / 255.0, alpha: alpha ?? 1.0)
    case .aBk:
      return UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 65.0 / 255.0, alpha: alpha ?? 1.0)
    case .aOg:
      return UIColor(red: 232.0 / 255.0, green: 113.0 / 255.0, blue: 91.0 / 255.0, alpha: alpha ?? 1.0)
    case .aPk:
      return UIColor(red: 237.0 / 255.0, green: 64.0 / 255.0, blue: 151.0 / 255.0, alpha: alpha ?? 1.0)
    case .dgr1:
      return UIColor(white: 130.0 / 255.0, alpha: alpha ?? 1.0)
    case .gr1:
      return UIColor(red: 180.0 / 255.0, green: 181.0 / 255.0, blue: 181.0 / 255.0, alpha: alpha ?? 1.0)
    case .lgr2:
      return UIColor(white: 242.0 / 255.0, alpha: alpha ?? 1.0)
    case .gr2:
      return UIColor(red: 147.0 / 255.0, green: 149.0 / 255.0, blue: 151.0 / 255.0, alpha: alpha ?? 1.0)
    case .lgr1:
      return UIColor(white: 247.0 / 255.0, alpha: alpha ?? 1.0)
    case .lgr3:
      return UIColor(red: 230.0 / 255.0, green: 231.0 / 255.0, blue: 232.0 / 255.0, alpha: alpha ?? 1.0)
    case .lgr4:
      return UIColor(white: 220.0 / 255.0, alpha: alpha ?? 1.0)
    case .aPp:
      return UIColor(red: 147.0 / 255.0, green: 90.0 / 255.0, blue: 168.0 / 255.0, alpha: alpha ?? 1.0)
    case .whiteTwo:
      return UIColor(white: 1.0, alpha: alpha ?? 1.0)
    case .aLpg:
      return UIColor(red: 243 / 255.0, green: 233 / 255.0, blue: 237 / 255.0, alpha: alpha ?? 1.0)
    case .dgr4:
      return UIColor(red: 92 / 255.0, green: 92 / 255.0, blue: 92 / 255.0, alpha: alpha ?? 1.0)
    case .dgr3:
      return UIColor(red: 88 / 255.0, green: 88 / 255.0, blue: 91 / 255.0, alpha: alpha ?? 1.0)
    case .dgr2:
      return UIColor(red: 44 / 255.0, green: 44 / 255.0, blue: 44 / 255.0, alpha: alpha ?? 1.0)
    case .amt:
      return UIColor(red: 61.0 / 255.0, green: 191.0 / 255.0, blue: 184.0 / 255.0, alpha: alpha ?? 1.0)
    case .aDpk:
      return UIColor(red: 182.0 / 255.0, green: 91.0 / 255.0, blue: 137.0 / 255.0, alpha: alpha ?? 1.0)
    case .aLpk:
      return UIColor(red: 248.0 / 255.0, green: 139.0 / 255.0, blue: 193.0 / 255.0, alpha: alpha ?? 1.0)
    case .aYw:
      return UIColor(red: 241.0 / 255.0, green: 171.0 / 255.0, blue: 74.0 / 255.0, alpha: alpha ?? 1.0)
    case .vermillion:
      return UIColor(red: 224.0 / 255.0, green: 32.0 / 255.0, blue: 32.0 / 255.0, alpha: alpha ?? 1.0)
    case .aBl:
      return UIColor(red: 27.0 / 255.0, green: 117.0 / 255.0, blue: 187.0 / 255.0, alpha: alpha ?? 1.0)
    case .aBl2:
      return UIColor(red: 25.0 / 255.0, green: 163.0 / 255.0, blue: 206.0 / 255.0, alpha: alpha ?? 1.0)
    case .peachyPink:
      return UIColor(red: 255.0 / 255.0, green: 134.0 / 255.0, blue: 127.0 / 255.0, alpha: alpha ?? 1.0)
    case .dusk:
      return UIColor(red: 71.0 / 255.0, green: 66.0 / 255.0, blue: 89.0 / 255.0, alpha: alpha ?? 1.0)
    case .paleGrey:
      return UIColor(red: 244.0 / 255.0, green: 243.0 / 255.0, blue: 251.0 / 255.0, alpha: alpha ?? 1.0)
    case .aVp:
      return UIColor(red: 214.0 / 255.0, green: 91.0 / 255.0, blue: 185.0 / 255.0, alpha: alpha ?? 1.0)
    case .pastelRed:
      return UIColor(red: 222.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: alpha ?? 1.0)
    case .blueyGreen:
      return UIColor(red: 46.0 / 255.0, green: 178.0 / 255.0, blue: 127.0 / 255.0, alpha: alpha ?? 1.0)
    case .blueyGreyThree:
      return UIColor(red: 146.0 / 255.0, green: 148.0 / 255.0, blue: 151.0 / 255.0, alpha: alpha ?? 1.0)
    case .aVb:
      return UIColor(red: 147.0 / 255.0, green: 138.0 / 255.0, blue: 215.0 / 255.0, alpha: alpha ?? 1.0)
    case .darkSkyBlue:
      return UIColor(red: 62.0 / 255.0, green: 181.0 / 255.0, blue: 219.0 / 255.0, alpha: alpha ?? 1.0)
    case .dark:
      return UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 72.0 / 255.0, alpha: alpha ?? 1.0)
    case .darkTwo:
      return UIColor(red: 49.0 / 255.0, green: 48.0 / 255.0, blue: 77.0 / 255.0, alpha: alpha ?? 1.0)
    case .darkThree:
      return UIColor(red: 47.0 / 255.0, green: 46.0 / 255.0, blue: 80.0 / 255.0, alpha: alpha ?? 1.0)
    case .manilla:
      return UIColor(red: 241.0 / 255.0, green: 238.0 / 255.0, blue: 142.0 / 255.0, alpha: alpha ?? 1.0)
    case .darkPeriwinkle:
      return UIColor(red: 108.0 / 255.0, green: 94.0 / 255.0, blue: 206.0 / 212.0, alpha: alpha ?? 1.0)
    case .brownGrayTwo:
      return UIColor(red: 151 / 255.0, green: 151 / 255.0, blue: 151 / 255.0, alpha: alpha ?? 1.0)
    case .perryWinkle:
      return UIColor(red: 147.0 / 255.0, green: 138.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    }
  }
}
