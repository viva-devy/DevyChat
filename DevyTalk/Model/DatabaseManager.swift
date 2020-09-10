//
//  DatabaseManager.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import MessageKit

final class DatabaseManager {
  
  static let shared = DatabaseManager()
  
  private let database = Database.database().reference()
  
  let locale = Locale.current
  
  static func safeEmail(emailAddress: String) -> String {
    var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "#", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "$", with: "-")
    return safeEmail
  }

}

extension DatabaseManager {
  /// Returns dictionary node at child path
  public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
    database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value else {
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
      
      completion(.success(value))
    }
  }
  
}


// MARK: Account Management: 계정관리
extension DatabaseManager {
  
  public func userExists(with email: String,
                         completion: @escaping((Bool) -> Void)) {
    
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
      guard snapshot.value as? [String: Any] != nil else {
        completion(false)
        return
      }
      
      completion(true)
    }
    
  }
  // FIRDataEventType에 따라 호출 될 수 있도록 선언
  // observe -> 호출
  // observeSingleEvent -> 한번 호출
  // value - 데이터 전체를 가지고 옴
  // childAdded - 노드에서 부터 추가되는 데이터를 감지
  // childRemoved - 노드에서 부터 변경되는 데이터를 감지
  // childMoved - 노드에서 부터 이동하는 데이터를 감지
  
  // 실시간데이터베이스 쓰기
  // childByAutold - 고유값 생성
  // setValue - 데이터를 저장할때
  // updateChildValues - 데이터를 수정 혹은 저장 할때
  // runTransactionBlock - 데이터를 순차적으로 저장 수정 해야 할때 - 페북 좋아요
  // MARK: 1. 사용자있는지 확인 후 존재 안하면 데이터베이스에 새 사용자 넣기
  public func insertUser(with user: UserData, completion: @escaping (Bool) -> Void) {
    let ref = database.child("users").child(user.docID ?? "docID")
    ref.observeSingleEvent(of: .value, with: { snapshop in
      if !snapshop.exists() {
        print("존재 안함")
          let newelement = [
            "call_DATE": user.callDATE,          // 앱에서는 사용안함 default
            "country": user.country,
            "check": user.check,
            "doc_BIRTH": user.docBIRTH,
            "doc_EMAIL": user.docEMAIL,
            "doc_GENDER": user.docGENDER,           // 1이면 남, 2면 여
            "doc_ID": user.docID,      //사용자 UID
            "doc_NAME": user.docNAME,          // 내 이름
            "doc_PHONE": user.docPHONE,
            "doc_PIC": user.docPIC,            // 사용자 프로필 Url - 수집안함
            "doc_POSITION": user.docPOSITION,     // 앱에서는 환자 default
            "hos_ID": user.hosID,             // 사용자 소속 병원키 - 환자는 "0",
            "hos_NAME": user.hosNAME,            // 사용자 소속 병원 - 환자는 "0"
            "remote_STATE": -1,         // 비대면에서사용
            "reser_DATE": "0",          // 비대면에서사용
            "tf_DOC": user.tfDOC,               // 99환자 디폴트
            ] as [String : Any]
      
          ref.setValue(newelement, withCompletionBlock: { error, _ in
            guard error == nil else {
              print(error?.localizedDescription)
              completion(false)
              return
            }
            completion(true)
            
          })
        
      } else {
        completion(true)
      }
    })
    

  }
  
  // MARK: 2. 채팅방 리스트 확인 childAdded
  func checkChatList(_ uid: String, completion: @escaping (Result<ChatList, DatabaseError>) -> Void) {
    let ref = database.child("users").child(uid).child("chats")
    
    ref.observe(.childAdded) { snapshot in
      guard snapshot.exists() else {
        // no chats
        print("nothing add")
        return }
      
      // have chat list
      guard let value = snapshot.value as? [String: Any] else {
        print("no value add")
        return }
      
      guard let list = try? ChatList(dictionary: value) else {
        completion(.failure(.failedToFetch))
        return
      }
//      print("run in Added")
      completion(.success(list))
    }
    
    // 테스트 value 생성
//    guard let data = try? JSONEncoder().encode(tempChatListModel) else { return }
//    let temp = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
//    guard let json = temp else { return }
//    ref.child("-chatRoomUID4").setValue(json)
    
  }
  
  // MARK: 2. 채팅방 리스트 확인 childChanged
  func checkLastMessage(_ uid: String, completion: @escaping (Result<ChatList, DatabaseError>) -> Void) {
    let ref = database.child("users").child(uid).child("chats")
    ref.observe(.childChanged) { snapshot in
      
      guard snapshot.exists() else {
        // no chats
        print("nothing changed")
        return }
      
      // have chat list
      guard let value = snapshot.value as? [String: Any] else {
        print("no value changed")
        return }
      
      guard let list = try? ChatList(dictionary: value) else {
        completion(.failure(.failedToFetch))
        return
      }
      print("run in changed")
      completion(.success(list))
    }
    
  }
  
  // MARK: 3. 채팅방 탐색
  func findChat(hosKey: String, completion: @escaping (Result<[String: Any], DatabaseError>) -> Void) {
    let ref = database.child("users")
//    var isExists: Bool = false
    ref.observeSingleEvent(of: .value) { snapshot in
      
      if snapshot.exists() {
//        print("존재", snapshot.value)
        guard let value = snapshot.value as? [String: [String: Any]] else {   // [user: [country: "KR"]]
          // no user
          print("1")
          completion(.failure(.failedToFetch))
          return
        }
        
        let temp = value.compactMap { (key, value) -> [String: Any]? in
          guard let hosID = value["hos_ID"] as? String else { return nil }
          guard hosID == hosKey else { return nil }
          return value
        }
        
        if let firstUser = temp.first(where: { ($0["tf_DOC"] as? Int) == 2 }) {
          completion(.success(firstUser))
          return 
        } else if let secondUser = temp.first(where: { ($0["tf_DOC"] as? Int) == 0 }) {
          completion(.success(secondUser))
          return
        }
        
        completion(.failure(.noUser))

      } else {
        print("미존재 2")
        completion(.failure(.failedToFetch))        // 존재하지 않으면 종료
      }
      
    }
  }
  
  // MARK: 3. 채팅방 생성
  func createChatRoom(otherKey: String, myKey: String, hosKey: String, name: String, completion: @escaping (String) -> Void, titleCompletion: @escaping (String) -> ()) {
    var isSentMessage: Bool = false
    let ref = database.child("users").child(myKey).child("chats")
    let mChatRef = ref.childByAutoId()
    guard let mChatID = mChatRef.key else {
      print("fail to make random key")
      return }     // mChatId 랜덤 생성
    
    let chatMemberRef = database.child("chat_members").child(mChatID)      // chat_members
    
    var chatList = ChatList(id: mChatID, hosID: hosKey, name: name)       // name: docName
    
    let userArr: [String] = [otherKey, myKey]   // user안에 간호사랑 원무과를 골랐을때
    print("UserArr: ", userArr)
    chatList.cTotalUnreadCount = userArr.count - 1
    
    userArr.forEach {
      database.child("users").child($0).observeSingleEvent(of: .value) { (snap) in
        if var dict = snap.value as? [String: Any] {
          
          if let userID = dict["doc_ID"] as? String {
            
//            guard let userData = try? JSONEncoder().encode(user) else {
//              print("fail to convert user to jsonData1")
//              return }
//            let userTemp = (try? JSONSerialization.jsonObject(with: userData, options: .allowFragments)).flatMap { $0 as? [String: Any] }
//            guard let userJson = userTemp else {
//              print("UserJson is nil")
//              return }
            
            guard let chatListData = try? JSONEncoder().encode(chatList) else {
              print("fail to convert user to jsonData2")
              return }
            let chatListTemp = (try? JSONSerialization.jsonObject(with: chatListData, options: .allowFragments)).flatMap { $0 as? [String: Any] }
            guard let chatListJson = chatListTemp else {
              print("chatListJson is nil")
              return }
            
            dict.removeValue(forKey: "chats")
            chatMemberRef.child(userID).setValue(dict) { (err, dbRef) in
              guard err == nil else {
                print(err?.localizedDescription)
                return }
              snap.ref.child("chats").child(mChatID).setValue(chatListJson) { _,_  in
                completion(mChatID)
              }
              if !isSentMessage {
                // need to send auto message and change title
                self.sendMessage(text: "하이요~ㅋㅋ", chatID: mChatID, user: try? UserData(dictionary: dict))
                self.addChatList(chatRef: mChatRef, completion: titleCompletion)    // titleCompletion - title이 변경되면 보내는것
                isSentMessage = true
              }
              
            }
          } else {
            print("fail to make UserData")
          }
          
        } else {
          print("snap value is nil")
        }
        
      }
    }
      
    
    
  }
  
  // 메세지 보낸 기록이 있는지 확인                          // [docId: [m_messageUser: [country: "KR"]]]??
  func getChatLog(id: String, completion: @escaping ([String: [String: Any]]) -> ()) {
    let logRef = database.child("chat_messages").child(id)
    logRef.observe(.value) {
      guard $0.exists() else {    // 존재하는지 확인
        print("비었음")
        completion([:])
        return }
      guard let value = $0.value as? [String: [String: Any]] else {
        print("형변환 실패")
        completion([:])
        return }
      completion(value)
    }
  }
  
  func checkReadSign(id: String) {
    let members = database.child("chat_members").child(id)
    members.observeSingleEvent(of: .value) {
      guard let value = $0.value as? [String: Any] else { return }
      let member = value.keys
      member.forEach {
        let userRef = self.database.child("users").child($0).child("chats").child(id)
        userRef.child("c_totalUnreadCount").setValue(0)
      }
    }
  }
  
  func configureRead(list: [String], chatID: String, mID: String) {
    guard let myUID = UserMe.shared.user.docID else { return }
    print("readCheck: ", list, myUID)
    guard !list.contains(myUID) else { return }
    let ref = database.child("chat_messages").child(chatID).child(mID)
    
    ref.child("m_readUserList").runTransactionBlock { (data) -> TransactionResult in
      guard var userList = data.value as? [String] else { return .abort() }
      userList.append(myUID)
      data.value = userList
      return .success(withValue: data)
    }
    
    ref.child("m_unreadCount").runTransactionBlock { (data) -> TransactionResult in
      guard let count = data.value as? Int else { return .abort() }
      data.value = count < 1 ? 0 : count - 1
      return .success(withValue: data)
    }
    
  }
  
  private func addChatList(chatRef: DatabaseReference, completion: @escaping (String) -> ()) {
    chatRef.ref.child("title").observe(.value) { (snap) in
      guard let title = snap.value as? String else { return }
      completion(title)
    }
  }
  
  
  func removeChat(_ uid: String) {
    let ref = database.child("users").child(uid).child("chats")
    ref.observe(.childRemoved, with: { snapshot in
      
      guard let value = snapshot.value as? [String: Any] else {
        print("no value change")
        return }
      
    })
    
    
  }
  
  // 모든 사용자 가져오기
  public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
    database.child("users").observeSingleEvent(of: .value, with: { snapshot in
      guard let value = snapshot.value as? [[String: String]] else {
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
      
      completion(.success(value))
      
    })
    
  }
  
  
  public enum DatabaseError: Error {
    case failedToFetch, noUser
  }
  

}

// MARK: Sending message / conversations    : 메세지 보내기, 대화
extension DatabaseManager {
  
// Create a new conversation with target user email and first message send , 이메일, 첫번째 메세지 - 새 대화 만들기
  public func createnewConversation(with otherUserEmail: String, name: String , firstMessage: Message, completion: @escaping (Bool) -> Void) {
    guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
      let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
        return
    }
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
    let ref = database.child("\(safeEmail)")
    
    ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
      guard var userNode = snapshot.value as? [String: Any] else {
        completion(false)
        print("user not found")
        return
      }
      
      let messageDate = firstMessage.sentDate
      let dateString = ChatViewController.dateFormatter.string(from: messageDate)
      
      var message = ""
      
      switch firstMessage.kind {
      case .text(let messageText):
        message = messageText
      case .attributedText(_):
        break
      default:
        break
        
      }
      
      let conversationId = "conversation_\(firstMessage.messageId)"
      // 새로운 대화 데이터
      let newConversationData: [String: Any] = [
        "id": conversationId,
        "other_user_email": otherUserEmail,
        "name": name,
        "latest_message": [
          "date": dateString,
          "message": message,
          "test": false,
          "is_read": false      // 읽음처리 따로 하지 않음
        ]
      ]
      // recipient_newConversationData      // 수신자 새로운 대화 데이터
      let recipientNewConversationData: [String: Any] = [
        "id": conversationId,
        "other_user_email": safeEmail,
        "name": currentName,
        "latest_message": [
          "date": dateString,
          "message": message,
          "test": false,
          "is_read": false
        ]
      ]
      // update recipient conversation entry. 수신자 대화 항목 업데이트
      self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
        if var conversations = snapshot.value as? [[String: Any]] {
          // append
          conversations.append(recipientNewConversationData)
          self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
        } else {
          // create
          self?.database.child("\(otherUserEmail)/conversations").setValue([recipientNewConversationData])
        }
        
      })
      
      
      // update current user conversation entry  현재 사용자 대화 항목 업데이트
      if var conversations = userNode["conversations"] as? [[String: Any]] {
        // conversation array exists for current user    현재 사용자에 대한 대화 배열 안에 append하기
        // you should appen
        conversations.append(newConversationData)
        userNode["conversations"] = conversations
        ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
          guard error == nil else {
            completion(false)
            return
          }
          self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
          
        })
      } else {
        // conversation array does NOT exist    대화 배열이 존재하지 않을때 생성하기
        // creat it
        userNode["conversations"] = [
          newConversationData
        ]
        
        ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
          guard error == nil else {
            completion(false)
            return
          }
          
          self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
          
          
        })
        
      }
      
    })
    
    
  }
  
  func sendMessage(text: String, chatID: String, user: UserData? = nil) {
    let chatMemberRef = database.child("chat_messages").child(chatID).childByAutoId()
     
    guard let childKey = chatMemberRef.key else { return }
    
//    let now = Date().toMessageDate()
//    let nowData = (try? JSONEncoder().encode(now)) ?? Data()
//    let nowTemp = (try? JSONSerialization.jsonObject(with: nowData, options: .allowFragments)).flatMap { $0 as? [String: Any] }
//
//    database.child("tempRef").child(childKey).setValue(nowTemp ?? [:])
    
    let mDate = Date().toMessageDate()
    
    guard let mDateData = try? JSONEncoder().encode(mDate) else {
      print("fail to convert user to mDateData")
      return }
    let mDateTemp = (try? JSONSerialization.jsonObject(with: mDateData, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    guard let mDateJson = mDateTemp else {
      print("mDateJson is nil")
      return }
    var lastUser = user == nil ? UserMe.shared.user : user!
    lastUser.chats = nil
    guard let userData = try? JSONEncoder().encode(lastUser) else {
      print("fail to convert user to mDateData")
      return }
    let userTemp = (try? JSONSerialization.jsonObject(with: userData, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    guard let userJson = userTemp else {
      print("mDateJson is nil")
      return }
    
    
    
    let sendMessage: [String: Any] = [
      "m_chatid": chatID,
      "m_messageDate": mDateJson,
      "m_messageId": childKey,
      "m_messageType": "TEXT", //수정해줘야함.
      "m_messageUser": userJson,
      "m_readUserList": [UserMe.shared.user.docID ?? "Error"],
      "m_unreadCount": 0, // setLastMessage 에서 수정함.
      "message": text,
      "tm_int": 0
    ]
    
    
    self.setLastMessage(chatID: chatID, lastMessage: sendMessage, userName: lastUser.docNAME ?? "Error") {
      chatMemberRef.setValue($0)
    }
    
  }
  
  private func setLastMessage(chatID: String, lastMessage: [String: Any], userName: String, completion: @escaping ([String: Any]) -> ()) {
    let members = database.child("chat_members").child(chatID)
    members.observeSingleEvent(of: .value) {
      guard let value = $0.value as? [String: Any] else { return }
      let member = value.keys
      var message = lastMessage
      message.updateValue(member.count - 1, forKey: "m_unreadCount")
      completion(message)
      
      member.forEach { key in
        let userRef = self.database.child("users").child(key).child("chats").child(chatID)
        userRef.child("lastMessage").setValue(message)
        userRef.child("title").setValue(userName)
        
        if key != UserMe.shared.user.docID {
          userRef.child("c_totalUnreadCount").runTransactionBlock { (data) -> TransactionResult in
            let totalUnreadCount = (data.value as? Int) ?? 0
            data.value = totalUnreadCount + 1
            return .success(withValue: data)
          }
        }
      }
    }
  }
  
  // 대화 만들기 완료
  private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
    
    
    let messageDate = firstMessage.sentDate
    let dateString = ChatViewController.dateFormatter.string(from: messageDate)
    
    var message = ""
    
    switch firstMessage.kind {
    case .text(let messageText):
      message = messageText
    case .attributedText(_):
      break
    default:
      break
    }
    
    guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
      completion(false)
      return
    }
    
    let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
    
    // 대화 내용 -
//    let collectionMessage: [String: Any] = [
//      "id": firstMessage.messageId,
//      "type": firstMessage.kind.messageKindString,
//      "content": message,
//      "date": dateString,
//      "sender_email": currentUserEmail,
//      "is_read": false,
//      "name": name
//
//    ]
    
    if let countryCode = locale.regionCode {
         print("countryCode: " ,countryCode.uppercased())
      countryCode.lowercased()
    }
    
    let collectionMessage: [String: Any] = [
      "cell_DATE": "0",          // 앱에서는 사용안함 default
      "chats": "",
      "country": "\(locale.regionCode?.lowercased())",
      "doc_BIRTH": "19901218",
      "doc_EMAIL": currentUserEmail,
      "doc_GENDER": 2,           // 1이면 남, 2면 여
      "doc_ID:": firstMessage.messageId,      //사용자 UID
      "doc_NAME": name,          // 내 이름
      "doc_PHONE": "01012345678",
      "doc_PIC": "0",            // 사용자 프로필 Url - 수집안함
      "doc_POSITION": "환자",     // 앱에서는 환자 default
      "hos_ID": "0",             // 사용자 소속 병원키 - 환자는 "0",
      "hos_NAME": "0",            // 사용자 소속 병원 - 환자는 "0"
      "remote_STATE": -1,         // 비대면에서사용
      "reser_DATE": "0",          // 비대면에서사용
      "tf_DOC": 99,               // 99환자 디폴트
      
//      "type": firstMessage.kind.messageKindString,    // messageKit - text
//      "content": message,        // 메세지 내용
//      "date": dateString,        // 날짜
//      "sender_email": currentUserEmail,     // 현재 유저 이메일
//      "is_read": false,          // 읽음 표시 - 따로 처리는 안했음

      
    ]
    
    let value: [String: Any] = [
      "messages": [
        collectionMessage
      ]
    ]
    
    print("adding convo: ", conversationID)
    
    database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
      guard error == nil else {
        completion(false)
        return
      }
      completion(true)
      
    })
  }
  
  // Fetches and returns all conversations for the user with passed in email, 이메일로 전달 된 사용자의 모든 대화 반환
  public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
    database.child("\(email)/conversations").observe(.value, with: { snapshot in
      guard let value = snapshot.value as? [[String: Any]] else{
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
      
      let conversations: [Conversation] = value.compactMap({ dictionary in
        guard let conversationId = dictionary["id"] as? String,
          let name = dictionary["name"] as? String,
          let otherUserEmail = dictionary["other_user_email"] as? String,
          let latestMessage = dictionary["latest_message"] as? [String: Any],
          let date = latestMessage["date"] as? String,
          let message = latestMessage["message"] as? String,
          let isRead = latestMessage["is_read"] as? Bool else {
            return nil
        }
        
        let latestMmessageObject = LatestMessage(date: date,
                                                 text: message,
                                                 isRead: isRead)
        return Conversation(id: conversationId,
                            name: name,
                            otherUserEmail: otherUserEmail,
                            latestMessage: latestMmessageObject)
      })
      print("conversations", conversations)
      completion(.success(conversations))
    })
  }
  
  

  
  // Gets all messages for a given conversation, 주어진 대화에 대한 모든 메세지를 가져옴
  public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
    database.child("\(id)/messages").observe(.value, with: { snapshot in
      guard let value = snapshot.value as? [[String: Any]] else {
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
//      print("value: ", value)
      let messages: [Message] = value.compactMap({ dictionary in
        guard let name = dictionary["name"] as? String,
          let isRead = dictionary["is_read"] as? Bool,
          let messageID = dictionary["id"] as? String,
          let content = dictionary["content"] as? String,
          let senderEmail = dictionary["sender_email"] as? String,
          let type = dictionary["type"] as? String,
          let dateString = dictionary["date"] as? String else {
            print("return nil")
            return nil
        }
        
        var kind: MessageKind?
        if type == "photo" {
          // photo
          guard let imageUrl = URL(string: content),
          let placeHolder = UIImage(named: "picADD") else {
            return nil
          }
          let media = Media(url: imageUrl, image: nil, placeholderImage: placeHolder, size: CGSize(width: 300.i, height: 300.i))
          kind = .photo(media)
        } else if type == "video" {
          // video
          guard let videoUrl = URL(string: content),
            let placeHolder = UIImage(named: "video") else {
              return nil
          }
          
          let media = Media(url: videoUrl,
                            image: nil,
                            placeholderImage: placeHolder,
                            size: CGSize(width: 300, height: 300))
          kind = .video(media)
        } else {
          kind = .text(content)
        }
        
        guard let finalKind = kind else {
          return nil
        }
        
        let date2 = Date().getDate(date: dateString)
        let sender = Sender(senderId: senderEmail, displayName: name)
        
        return Message(sender: sender,
                       messageId: messageID,
                       sentDate: date2,
                       kind: finalKind)
        
      })
      
      completion(.success(messages))
      
      
    })
    
    
  }
  
  // Sends a message with target conversation and message, 대화한 내용 메시지 보내기
  public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
    // add new messages.   새 메시지 추가
    // update sender latest message. 발신자 최신 메시지 업데이트
    // update recipient latest message   수신자 최신 메시지 업데이트
    guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
      completion(false)
      return
    }
    
    let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
    
    database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
      guard let strongSelf = self else {
        return
      }
      
      guard var currentMessages = snapshot.value as? [[String: Any]] else {
        completion(false)
        return
      }
      
      let messageDate = newMessage.sentDate
      let dateString = ChatViewController.dateFormatter.string(from: messageDate)
      
      var message = ""
      switch newMessage.kind {
      case .text(let messageText):
        message = messageText
      case .attributedText(_):
        break
      case .photo(let mediaItem):
        if let targetUrlString = mediaItem.url?.absoluteString {
          message = targetUrlString
        }
        break
      case .video(let mediaItem):
        if let targetUrlString = mediaItem.url?.absoluteString {
          message = targetUrlString
        }
        break
      default:
        break
      }
      
      guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
        completion(false)
        return
      }
      
      let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)
      
      let newMessageEntry: [String: Any] = [
        "id": newMessage.messageId,
        "type": newMessage.kind.messageKindString,
        "content": message,
        "date": dateString,
        "sender_email": currentUserEmail,
        "is_read": false,
        "name": name
      ]
      
      currentMessages.append(newMessageEntry)
      
      strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
        guard error == nil else {
          completion(false)
          return
        }
        
        
        strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
          
          guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
            completion(false)
            return
          }
          
          let updatedValue: [String: Any] = [
            "date": dateString,
            "is_read": false,
            "message": message
          ]
          
          var targetConversation: [String: Any]?
          var position = 0
          
          for conversationDictionary in currentUserConversations {
            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
              targetConversation = conversationDictionary
              
              break
            }
            
            position += 1
          }
          
          targetConversation?["latest_message"] = updatedValue
          
          guard let finalConversation = targetConversation else {
            completion(false)
            return
          }
          
          currentUserConversations[position] = finalConversation
          strongSelf.database.child("\(currentEmail)/conversations").setValue(currentUserConversations, withCompletionBlock: { error, _ in
            guard error == nil else {
              completion(false)
              return
            }
            
            
            // update latest message for recipient user. 수신자 사용자에 대한 최신 메시지 업데이트

            strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
              guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
              }
              
              let updatedValue: [String: Any] = [
                "date": dateString,
                "is_read": false,
                "message": message
              ]
              
              var targetConversation: [String: Any]?
              var position = 0
              
              for conversationDictionary in otherUserConversations {
                if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                  targetConversation = conversationDictionary
                  break
                }
                
                position += 1
              }
              
              targetConversation?["latest_message"] = updatedValue
              guard let finalConversation = targetConversation else {
                completion(false)
                return
              }
              
              otherUserConversations[position] = finalConversation
              
              strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                guard error == nil else {
                  completion(false)
                  return
                }
              })
            })


            completion(true)
            
          })
        })
        
      }
    })
  }
  
  // 대화 삭제
  public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
      return
    }
    
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
      print("Deleting conversation with id: ", conversationId)
    
    // Get all conversation for current user.    현재 사용자의 모든 대화 가져 오기
    // delete conversation in collection with target id.   대상 ID가있는 컬렉션에서 대화 삭제
    // reset those conversations for the user in database. 데이터베이스에서 사용자에 대한 대화를 재설정
    let ref = database.child("\(safeEmail)/conversations")
//        ref.observe(.childChanged, with:  )
    ref.observeSingleEvent(of: .value, with: { snapshot in
      if var conversations = snapshot.value as? [[String: Any]] {
        var positionToRemove = 0
        for conversation in conversations {
          if let id = conversation["id"] as? String,
            id == conversationId {
            print("found conversation to delete")
            break
          }
          
          positionToRemove += 1
        }
        conversations.remove(at: positionToRemove)
        ref.setValue(conversations, withCompletionBlock: { error, _ in
          guard error == nil else {
            completion(false)
            print("failed to write new conversation array")
            return
          }
          print("deleted conversation")
          completion(true)
          
        })
        
      }
      
      
    })
    
    
  }
  
  // 대화있을때
  public func conversationExists(with targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
    let safeRecipientEmail = DatabaseManager.safeEmail(emailAddress: targetRecipientEmail)
    guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
      return
    }
    let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: senderEmail)
    
    database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
      guard let collection = snapshot.value as? [[String: Any]] else {
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
      
      // iterate and find conversation with target sender    대상 발신자와 반복 및 대화 찾기
      if let conversation = collection.first(where: {
        guard let targetSenderEmail = $0["other_user_email"] as? String else {
          return false
        }
        return safeSenderEmail == targetSenderEmail
      }) {
        // get id.   아이디 가져오기
        guard let id = conversation["id"] as? String else {
          completion(.failure(DatabaseError.failedToFetch))
          return
        }
        completion(.success(id))
        return
      }
      
      completion(.failure(DatabaseError.failedToFetch))
      return
    })
  }
  
  
}

struct ChatAppUser {
  let firstName: String
  let lastName: String
  let emailAddress: String
  
  var safeEmail: String {
    var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "#")
    safeEmail = safeEmail.replacingOccurrences(of: "#", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "$", with: "-")
    return safeEmail
  }
  
  //heajijeon-gamil-com_prifile_picture.png
  var profilePictureFileName: String {
    return "\(safeEmail)_profile_picture.png"
  }
  
}


