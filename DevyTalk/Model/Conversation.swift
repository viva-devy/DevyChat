//
//  Conversation.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/27.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

struct Conversation {
  let id: String
  let name: String
  let otherUserEmail: String
  let latestMessage: LatestMessage
}

struct LatestMessage {
  let date: String
  let text: String
  let isRead: Bool
}
