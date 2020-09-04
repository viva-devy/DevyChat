//
//  Message.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/26.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
 public var sender: SenderType
 public var messageId: String
 public var sentDate: Date
 public var kind: MessageKind
  
}

//extension MessageKind {
//  var messageKindString: String {
//    switch self {
//    case .text(_):
//      return "text"
//    case .attributedText(_):
//      return "attributedText"
//    case .photo(_):
//      return "photo"
//    case .video(_):
//      return "video"
//    case .location(_):
//      return "location"
//    case .emoji(_):
//      return "emoji"
//    case .audio(_):
//      return "audio"
//    case .contact(_):
//      return "contact"
//    case .custom(_):
//      return "custom"
//    case .linkPreview(_):
//      return "linkPreview"
//
//    }
//  }
//}

struct Sender: SenderType {
  public var senderId: String       // 보낸사람 아이디
  public var displayName: String    // 보낸사람이름
  
}

struct Media: MediaItem {
  var url: URL?
  var image: UIImage?
  var placeholderImage: UIImage
  var size: CGSize

}


