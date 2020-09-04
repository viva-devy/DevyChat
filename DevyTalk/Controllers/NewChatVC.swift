//
//  NewChatVC.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/31.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import MessageKit
import InputBarAccessoryView

class NewChatVC: MessagesViewController {
  
  var chatID: String = ""
  
  var hosData: (String, String) = ("", "")        //(chatUser.hosID ?? "hosID", chatUser.hosNAME ?? "hosName")
  
  var messageLog: [BasicMessageModel] = [] {      // 메세지 보낸 기록이 있는 화면
    didSet {
      
      DispatchQueue.main.async {
        self.messagesCollectionView.reloadData()
        self.messageInputBar.inputTextView.becomeFirstResponder()
        self.messagesCollectionView.scrollToLastItem()
//        self.messagesCollectionView.reloadDataAndKeepOffset()
        
      }
    }
  }
  
  var selfSender: Sender? {
    guard let id = UserMe.shared.user.docID else { return nil }
    
    return Sender(senderId: id, displayName: "Me")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appColor(.lgr1)
    setupNavi()
    checkFirts()
    guard chatID != "" else {
      print("chatID is empty")
      self.navigationController?.popViewController(animated: true)
      return }
    getChatLog(chatID: chatID) {
      self.messageLog = $0.values.map { (origin) -> TextMessageModel in
        let id = origin["m_chatid"] as? String
        let delta = (origin["m_messageDate"] as? [String: Any])?["time"] as? Int ?? 0
        let messageId = origin["m_messageId"] as? String
        let type = origin["m_messageType"] as? String
        let user = try? UserData(dictionary: (origin["m_messageUser"] as? [String: Any]) ?? [:])
        // [String: Any]타입의 딕셔너리로 Userdata를 생성한다.
        let list = origin["m_readUserList"] as? [String]
        let unread = origin["m_unreadCoung"] as? Int
        let message = origin["message"] as? String
        let tm = origin["tm_int"] as? Int
        
        return TextMessageModel(ID: id ?? "", date: Date(timeIntervalSince1970: TimeInterval(delta)), messageId: messageId ?? "", type: type ?? "", user: user ?? UserData(), list: list ?? [], unread: unread ?? 0, message: message ?? "", tmInt: tm ?? 0)
      }.sorted(by: { (lef, ref) -> Bool in
        lef.sentDate < ref.sentDate
      })
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)


   }
  
  // 보낸기록이 있는지 확인
  private func getChatLog(chatID: String, completion: @escaping ([String: [String: Any]]) -> ()) {
    DatabaseManager.shared.getChatLog(id: chatID, completion: completion)
  }
  
  private func checkFirts() {
    messagesCollectionView.backgroundColor = .appColor(.lgr1)
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
    messageInputBar.delegate = self
    
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true // default false
    
    
    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
      layout.setMessageIncomingAvatarPosition(.init(vertical: .cellTop))
      layout.setMessageIncomingAvatarSize(CGSize(width: 28.i, height: 28.i))
      layout.setAvatarLeadingTrailingPadding(7.i)
      layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 9.i, bottom: 0, right: 87.i))
      layout.setMessageOutgoingAvatarSize(.zero)
      layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .natural, textInsets: UIEdgeInsets(top: 0, left: 7.i + 28.i + 9.i, bottom: 7.i, right: 0)))
      layout.setMessageIncomingCellBottomLabelAlignment(LabelAlignment(textAlignment: .natural, textInsets: UIEdgeInsets(top: 0, left: 7.i + 28.i + 9.i, bottom: 0, right: 0)))
      layout.setMessageOutgoingCellBottomLabelAlignment(LabelAlignment(textAlignment: .natural, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7.i)))
      
    }
  }
  
  
  
  private func setupNavi() {
    let leftBarBtn = UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(didTapButton(_:)))
    leftBarBtn.tintColor = .appColor(.aBk)
    navigationItem.leftBarButtonItem = leftBarBtn
    
    let rightBtn = UIBarButtonItem(image: UIImage(named: "language"), style: .done, target: self, action: #selector(rightBtnDidTap(_:)))
    navigationItem.rightBarButtonItem = rightBtn
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
  }
  
    @objc func didTapButton(_ sender: UIBarButtonItem) {
          navigationController?.popViewController(animated: true)
  //    navigationController?.popToRootViewController(animated: true)
    }
  
  
  @objc func rightBtnDidTap(_ sender: UIButton) {
    print("번역")
//    navigationController?.popToRootViewController(animated: true)
    //    navigationController?.popViewController(animated: true)
  }
}


extension NewChatVC: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    guard text != "" else { return }
    messagesCollectionView.scrollToBottom(animated: true)
    inputBar.inputTextView.text = ""
    inputBar.inputTextView.placeholder = "Message.."
    inputBar.inputTextView.font = UIFont(name: "NanumSquareR", size: 14.i)
    inputBar.sendButton.frame = CGRect(x: 0, y: 0, width: 30.i, height: 30.i)
    inputBar.sendButton.image = UIImage(named: "send")
    inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
    inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
    
    DatabaseManager.shared.sendMessage(text: text, chatID: chatID)
  }
  
  
  
  
}

extension NewChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return .appColor(message.sender.senderId == selfSender?.senderId ? .aPp : .whiteTwo)
  }
  
  func currentSender() -> SenderType {
    if let sender = selfSender {
      return sender
    }
    
    return Sender(senderId: UserMe.shared.user.docID ?? "docId", displayName: UserMe.shared.user.docNAME ?? "docNAME")
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messageLog[indexPath.section]
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messageLog.count
  }
  
  func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let attri = NSMutableAttributedString(string: message.sender.displayName)
    let font = UIFont(name: "NanumSquareB", size: 11.i) ?? UIFont()
    attri.addAttribute(.font, value: font, range: NSRange(location: 0, length: message.sender.displayName.count))
    attri.addAttribute(.foregroundColor, value: UIColor.appColor(.gr2), range: NSRange(location: 0, length: message.sender.displayName.count))
    
    return attri
  }
  
  func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let dateString = message.sentDate.toTimeString(date: message.sentDate)
    let attri = NSMutableAttributedString(string: dateString)
    let font = UIFont(name: "NanumSquareR", size: 9.i) ?? UIFont()
    
    attri.addAttribute(.font, value: font, range: NSRange(location: 0, length: dateString.count))
    attri.addAttribute(.foregroundColor, value: UIColor.appColor(.gr1), range: NSRange(location: 0, length: dateString.count))
    
    return attri
  }

  
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

    let inComming = { (view: MessageContainerView) in
      view.layer.cornerRadius = 12.i
      view.layer.borderWidth = CGFloat(0.5).iOS
      view.layer.borderColor = UIColor.appColor(.lgr4).cgColor
    }
    let outGoing = { (view: MessageContainerView) in
      view.layer.cornerRadius = 12.i
    }
    
    return message.sender.senderId == selfSender?.senderId ? .custom(outGoing) : .custom(inComming)
  }

  
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    if message.sender.senderId == selfSender?.senderId {
      return 0
    } else {
      return 20.i
    }
  }
  
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 10.i
  }

  
}

extension NewChatVC: MessageCellDelegate {
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    let log = messageLog[indexPath.section]
    avatarView.isHidden = log.sender.senderId == selfSender?.senderId
  }
}
