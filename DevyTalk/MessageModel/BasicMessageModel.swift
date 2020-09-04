//
//  BasicMessageModel.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/03.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import MessageKit

class BasicMessageModel: MessageType {
  var sender: SenderType = Sender(senderId: "", displayName: "")
  var messageId: String = ""                // m_messageId
  var sentDate: Date = Date()               // m_messageDate
  var kind: MessageKind = .text("TEXT")     // m_messageType
  var messageUser: UserData = UserData()    // m_messageUser
  var unreadCount: Int = 0                  // m_unreadCount
  var readUserArr: [String] = []            // m_readUserList
  var chatId: String = ""                   // m_chatid
  
//  var checked: Bool = false
  var translated: Bool = false
  
}

extension MessageKind {
  var messageKindString: String {
    switch self {
    case .text(_):
      return "TEXT"
    case .attributedText(_):
      return "attributedText"
    case .photo(_):
      return "photo"
    case .video(_):
      return "video"
    case .location(_):
      return "location"
    case .emoji(_):
      return "emoji"
    case .audio(_):
      return "audio"
    case .contact(_):
      return "contact"
    case .custom(_):
      return "custom"
    case .linkPreview(_):
      return "linkPreview"

    }
  }
}

