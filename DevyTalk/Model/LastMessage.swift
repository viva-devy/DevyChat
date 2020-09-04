//
//  LastMessage.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/04.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

// MARK: - ChatModel
struct LastMessage: Codable {
  let mChatid: String?
  let mMessageDate: MessageDate?
  let mMessageID, mMessageType: String?
  let mMessageUser: MMessageUser?
  let mReadUserList: [String]?
  let mUnreadCount: Int?
  let message: String?
  let tmInt: Int?
  
  enum CodingKeys: String, CodingKey {
    case mChatid = "m_chatid"
    case mMessageDate = "m_messageDate"
    case mMessageID = "m_messageId"
    case mMessageType = "m_messageType"
    case mMessageUser = "m_messageUser"
    case mReadUserList = "m_readUserList"
    case mUnreadCount = "m_unreadCount"
    case message
    case tmInt = "tm_int"
  }
}

// MARK: - MMessageUser
struct MMessageUser: Codable {
    let callDATE: String
    let check: Bool
    let country, docBIRTH, docEMAIL: String
    let docGENDER: Int
    let docID, docNAME, docPHONE, docPIC: String
    let docPOSITION, hosID, hosNAME: String
    let remoteSTATE: Int
    let reserDATE: String
    let tfDOC: Int

    enum CodingKeys: String, CodingKey {
        case callDATE = "call_DATE"
        case check, country
        case docBIRTH = "doc_BIRTH"
        case docEMAIL = "doc_EMAIL"
        case docGENDER = "doc_GENDER"
        case docID = "doc_ID"
        case docNAME = "doc_NAME"
        case docPHONE = "doc_PHONE"
        case docPIC = "doc_PIC"
        case docPOSITION = "doc_POSITION"
        case hosID = "hos_ID"
        case hosNAME = "hos_NAME"
        case remoteSTATE = "remote_STATE"
        case reserDATE = "reser_DATE"
        case tfDOC = "tf_DOC"
    }
}
