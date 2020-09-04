//
//  TextMessageModel.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/03.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

class TextMessageModel: BasicMessageModel {
  var message: String = ""
  var tmInt: Int = 0
  
  var hosName: String = ""
  var faxNum: String = ""
  
  init(ID: String, date: Date, messageId: String, type: String, user: UserData, list: [String], unread: Int, message: String, tmInt: Int) {
    super.init() 
    self.message = message
    self.messageId = messageId
    self.chatId = ID
    self.sentDate = date
    self.kind = .text(message)
    self.messageUser = user
    self.readUserArr = list
    self.unreadCount = unread
    self.tmInt = tmInt
    self.sender = Sender(senderId: user.docID ?? "docId", displayName: user.docNAME ?? "Error")
  }
}
