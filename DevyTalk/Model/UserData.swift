//
//  UserData.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/31.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

class UserMe {
  
  static let shared = UserMe()      // 상속 방지 및 외부 접근 가능
  private init() {}                 // 외부 생성 방지
  
  let user = UserData()
  
}

struct UserData: Codable {
  
  var callDATE: String?
  var chats: ChatList?
  var check: Bool?
  var country, docBIRTH, docEMAIL: String?
  var docGENDER: Int?
  var docID, docNAME, docPHONE, docPIC: String?
  var docPOSITION, hosID, hosNAME: String?
  var remoteSTATE: Int?
  var reserDATE: String?
  var tfDOC: Int?

  enum CodingKeys: String, CodingKey {
      case callDATE = "call_DATE"
      case chats, check, country
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

  init(dictionary: [String: Any]) throws {
    self = try JSONDecoder().decode(UserData.self, from: JSONSerialization.data(withJSONObject: dictionary))
  }
  
//  init() {
//    self.callDATE = "0"
//    self.chats = nil
//    self.country = "KR"
//    self.check = false
//    self.docBIRTH = "19901218"
//    self.docEMAIL = "viva@viva.viva"
//    self.docGENDER = 2
//    self.docID = "tempId"
//    self.docNAME = "환자임"
//    self.docPHONE = "01012345678"
//    self.docPIC = "0"
//    self.docPOSITION = "환자"
//    self.hosID = "0"
//    self.hosNAME = "0"
//    self.remoteSTATE = -1
//    self.reserDATE = "0"
//    self.tfDOC = 99
//  }
  
  init() { // 대전 선병원 원무과의 홍길동
    self.callDATE = "0"
    self.chats = nil
    self.country = "KR"
    self.check = false
    self.docBIRTH = "19910228"
    self.docEMAIL = "hosAdmin@viva.com"
    self.docGENDER = 2
    self.docID = "tempHosAdmin"
    self.docNAME = "홍길동"
    self.docPHONE = "01011112222"
    self.docPIC = "0"
    self.docPOSITION = "원무과"
    self.hosID = "H24783"
    self.hosNAME = "대전선병원"
    self.remoteSTATE = -1
    self.reserDATE = "0"
    self.tfDOC = 2
  }
  
  
}



