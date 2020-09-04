//
//  ChatList.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

// MARK: - Chat
struct ChatList: Codable {
    let chatID: String?            // roomId
    let checked: Bool?
    let click: Bool?                // isClick??? click, clicked
    let createDate: MessageDate?
    let hosID: String?             // 대화방을 생성한 병원 키
    let isInner, membercount: Int? // memberCount -> 대화방 참여 인원 수
    let reserDate: String?         // 진료 예약 일자
    let roomstate: Int?            // 채팅방 상태
    let title: String?             // 채팅방 타이틀
    let translated: Bool?
    let lastMessage: LastMessage?        // 채팅방의 마지막 대화 객채
    let titlePic: String?         // 채팅방 타이틀 이미지
    var cTotalUnreadCount: Int?    // 메세지 안 읽은 사람 수
    let totalUnreadCount: Int?     // 안씀
  
  
    enum CodingKeys: String, CodingKey {
        case chatID = "chatId"
        case checked, click, createDate
        case hosID = "hos_id"
        case isInner, membercount
        case reserDate = "reser_Date"
        case roomstate, title, totalUnreadCount, translated, lastMessage
        case titlePic = "title_pic"
        case cTotalUnreadCount = "c_totalUnreadCount"
    }
  
  init(id: String, hosID: String, name: String) {
    self.chatID = id
    self.hosID = hosID
    self.title = name
    self.createDate = Date().toMessageDate()
    self.click = false
    checked = false
    isInner = 1
    membercount = 2
    reserDate = "0"
    roomstate = 2
    cTotalUnreadCount = 1
    totalUnreadCount = 0
    translated = false
    lastMessage = nil
    titlePic = "0"
  }
  
  init(dictionary: [String: Any]) throws {
    self = try JSONDecoder().decode(ChatList.self, from: JSONSerialization.data(withJSONObject: dictionary))
  }
}

// MARK: - LastMessage
struct Last: Codable {
  let message: String?
  let tmInt: Int?
  let hosName: String?
  let faxNum: String?
  
}

// MARK: - MessageDate
struct MessageDate: Codable {
    let date, day, hours, minutes: Int?
    let month, seconds, time, timezoneOffset: Int?
    let year: Int?
}


//let tempChatListModel = ChatList(chatID: "testChatID9",
//                                 checked: false,
//                                 click: false,
//                                 createDate: MessageDate(date: 18,
//                                                         day: 2,
//                                                         hours: 19,
//                                                         minutes: 55,
//                                                         month: 8,
//                                                         seconds: 24,
//                                                         time: 1597748004613,
//                                                         timezoneOffset: -540,
//                                                         year: 120),
//                                 hosID: "H24724",
//                                 isInner: 0,
//                                 membercount: 2,
//                                 reserDate: "",
//                                 roomstate: 0,
//                                 title: "TestTitle2",
//                                 translated: nil,
//                                 lastMessage: Last(message: "tempMessage",
//                                                   tmInt: 1,
//                                                   hosName: "tempHosName",
//                                                   faxNum: "tempFaxNum"),
//                                 titlePic: nil,
//                                 cTotalUnreadCount: 1,
//                                 totalUnreadCount: 1)
