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
  var kind: MessageKind = .attributedText(NSAttributedString())         // m_messageType
  var messageUser: UserData = UserData()    // m_messageUser
  var unreadCount: Int = 0                  // m_unreadCount
  var readUserArr: [String] = []            // m_readUserList
  var chatId: String = ""                   // m_chatid
  var message: String = ""
  
//  var checked: Bool = false
  var translated: Bool = false
  var originText: NSMutableAttributedString?
  var translatedText: NSMutableAttributedString?
  
  func translate(completion: @escaping (String) -> ()) {
    Trans().translate(target: message, completion: completion)
  }
  
  func toggleTrans(completion: @escaping () -> ()) {
    self.translated.toggle()
    let origin = originText ?? textToAttribute(message)
    if self.translated {
      guard self.translatedText == nil else {
        let item: (String, NSMutableAttributedString) = ("finish", translatedText!)
        self.kind = message == "finishNow" ? .custom(item) : .attributedText(translatedText!)
        DispatchQueue.main.async {
          completion()
        }
        return }
      self.translate() {
        let transAttri = self.textToAttribute($0)
        transAttri.addAttribute(.foregroundColor, value: UIColor.appColor(.aPp), range: NSMakeRange(0, transAttri.length))
        transAttri.insert(NSMutableAttributedString(string: "\n \n"), at: 0)
        transAttri.insert(origin, at: 0)
        self.translatedText = transAttri
        let item: (String, NSMutableAttributedString) = ("finish", self.translatedText!)
        self.kind = self.message == "finishNow" ? .custom(item) : .attributedText(self.translatedText!)
        DispatchQueue.main.async {
          completion()
        }
        return
      }
    } else {
      let item: (String, NSMutableAttributedString) = ("finish", origin)
      self.kind = message == "finishNow" ? .custom(item) : .attributedText(origin)
      DispatchQueue.main.async {
        completion()
      }
    }
    
  }
  
  func textToAttribute(_ text: String) -> NSMutableAttributedString {
    let attri = NSMutableAttributedString(string: text)
    let font = UIFont(name: "NanumSquareR", size: 13.i)!
    attri.addAttribute(.font, value: font, range: NSMakeRange(0, attri.length))
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6.i
    attri.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attri.length))
    guard let id = UserMe.shared.user.docID else { return attri }
    if id == sender.senderId {
      attri.addAttribute(.foregroundColor, value: UIColor.appColor(.whiteTwo), range: NSMakeRange(0, attri.length))
    }
    return attri
  }
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

