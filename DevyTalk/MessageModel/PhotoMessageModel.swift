//
//  PhotoMessageModel.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import MessageKit

class PhotoMessageModel: BasicMessageModel {

  var photoUrl: String = ""
  
  
  
  private func setKind(message: String) {
    if message == "finishNow" {
      let text = "사진이 전송 됐습니다."   // 영어?
      let attri = textToAttribute(text)
      super.originText = attri
      let item: (String, NSMutableAttributedString) = ("finish", attri)
      super.kind = .custom(item)
    } else {
      self.originText = textToAttribute(message)
      super.kind = .attributedText(self.originText ?? textToAttribute(message))
    }
  }
  
  

}

