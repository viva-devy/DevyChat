//
//  TextMessageModel.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/03.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class TextMessageModel: BasicMessageModel {
  var tmInt: Int = 0
  
  var hosName: String = ""
  var faxNum: String = ""
  
  init(ID: String, date: Date, messageId: String, type: String, user: UserData, list: [String], unread: Int, message: String, tmInt: Int) {
    super.init() 
    super.message = message
    super.messageId = messageId
    super.chatId = ID
    super.sentDate = date
    super.messageUser = user
    super.readUserArr = list
    super.unreadCount = unread
    self.tmInt = tmInt
    super.sender = Sender(senderId: user.docID ?? "docId", displayName: user.docNAME ?? "Error")
    
    // 이부분 테스트로 진행함
    
    setKind(message: message)
  }
  
  private func setKind(message: String) {
    if message == "finishNow" {
      let text = "Your non-face-to-face treatment is over. Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!"
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
