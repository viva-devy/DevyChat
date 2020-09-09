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
        self.messagesCollectionView.scrollToBottom()
        self.messageInputBar.inputTextView.becomeFirstResponder()
        self.setupInputButton()
        //        self.messagesCollectionView.reloadDataAndKeepOffset()
        
      }
    }
  }
  
  var customMessageSizeCalculator: MessageSizeCalculator?
  
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
      self.messageLog = $0.values.map { (origin) -> BasicMessageModel in
        self.convertToMessageLog(origin)
      }.sorted(by: { (lef, ref) -> Bool in
        lef.sentDate < ref.sentDate
      })
    }
    

  }
  
  private func convertToMessageLog(_ origin: [String: Any]) -> BasicMessageModel {
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
  }
  
  // 보낸기록이 있는지 확인
  private func getChatLog(chatID: String, completion: @escaping ([String: [String: Any]]) -> ()) {
    DatabaseManager.shared.getChatLog(id: chatID, completion: completion)
  }
  
  private func checkFirts() {
//    messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessageFlowLayout())
    messagesCollectionView.register(FinishNowCC.self)
    messagesCollectionView.backgroundColor = .appColor(.lgr1)
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
//    messagesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: -100, right: 0)
    
    
    messageInputBar.delegate = self
    self.additionalBottomInset = 20.i
    
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true // default false
    
    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
      let customCalculator = CustomMessageSizeCalculator(layout: layout)
      layout.addCalculator(customCalculator)
      layout.setMessageIncomingAvatarPosition(.init(vertical: .messageLabelTop))
      layout.setMessageIncomingAvatarSize(CGSize(width: 28.i, height: 28.i))
      layout.setAvatarLeadingTrailingPadding(7.i)
      layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 7.i, left: 9.i, bottom: 10.i, right: 27.i))
      layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 85.i, bottom: 10.i, right: 7.i))
      layout.setMessageOutgoingAvatarSize(.zero)
      layout.setMessageIncomingAccessoryViewSize(CGSize(width: 44.i, height: 0))
      layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 7.i + 28.i + 9.i, bottom: 0, right: 0)))
      layout.setMessageIncomingAccessoryViewPosition(.messageBottom)
      layout.setMessageOutgoingAccessoryViewPosition(.messageBottom)
      layout.attributedTextMessageSizeCalculator.incomingMessageLabelInsets = UIEdgeInsets(top: 9.i, left: 11.i, bottom: 9.i, right: 11.i)
      layout.attributedTextMessageSizeCalculator.outgoingMessageLabelInsets = UIEdgeInsets(top: 9.i, left: 11.i, bottom: 9.i, right: 11.i)
      
      customMessageSizeCalculator = customCalculator
//      layout.setMessageIncomingCellBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 7.i + 28.i + 9.i, bottom: 0, right: 0)))
//      layout.setMessageOutgoingCellBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7.i)))
//      layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))
//      layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
      
      
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
  }
  
  
  var sendBtn: InputBarButtonItem = {
    let btn = InputBarButtonItem()
    btn.setImage(UIImage(named: "send"), for: .normal)
    btn.setImage(UIImage(named: "send"), for: .highlighted)
    btn.contentMode = .scaleAspectFit
    return btn
  }()
  
  private func setupInputButton() {
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true
    
    let button = InputBarButtonItem()
    button.setSize(CGSize(width: 35, height: 35), animated: false)
    button.setImage(UIImage(named: "add"), for: .normal)
    button.onTouchUpInside { [weak self] (btn) in
      self?.configureMessageInputBarForChat()
    }
    messageInputBar.backgroundColor = .appColor(.lgr1)
    messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
    messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    
  }
  
  
  
  private func makeButton(named: String) -> InputBarButtonItem {
    return InputBarButtonItem()
      .configure {
      
        $0.spacing = .fixed(55.i)
//        $0.contentEdgeInsets = UIEdgeInsets(top: 12.i, left: 0, bottom: 10, right: 0)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30.i, bottom: 10, right: 0)
        $0.backgroundColor = .appColor(.lgr1)
        $0.titleLabel?.font = UIFont(name: "NanumSquareR", size: 13.i)
        $0.image = UIImage(named: named)
        
        $0.setSize(CGSize(width: 48.i, height: 110.i), animated: false)      // image
        $0.sizeToFit()
        $0.setTitleColor(UIColor.appColor(.dgr1), for: .normal)
//        $0.tintColor = UIColor(white: 0.8, alpha: 1)
    }
//    .onSelected {
//      $0.tintColor = .appColor(.gr1)
//    }.onDeselected {
//      $0.tintColor = UIColor(white: 0.8, alpha: 1)
//      .onSelected {
//      $0.titleLabel?.textColor = UIColor.appColor(.dgr1)
//    } .onDeselected {
//      $0.titleLabel?.textColor = UIColor.appColor(.dgr1)
//    }
    .onTouchUpInside { _ in
      print("Item Tapped")
    }
  }

  
  
  private func configureMessageInputBarForChat() {
//    messageInputBar.setMiddleContentView(CustomInputBar(), animated: false)
    messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
    
    let bottomItems = [makeButton(named: "album"), makeButton(named: "camera"), makeButton(named: "file"), .flexibleSpace]
    
    messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
    
    messageInputBar.sendButton.activityViewColor = .white
    messageInputBar.sendButton.backgroundColor = .appColor(.lgr1)
    messageInputBar.sendButton.layer.cornerRadius = 10
    messageInputBar.sendButton.setTitleColor(.white, for: .normal)
    messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .highlighted)
    messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .disabled)
    messageInputBar.sendButton
      .onSelected { item in
        item.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
    }.onDeselected { item in
      item.transform = .identity
    }
  }
  
  private func hideMessageInputBarForChat() {
    messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
//    messageInputBar.setRightStackViewWidthConstant(to: 52, animated: false)
//    let bottomItems = [makeButton(named: "album"), makeButton(named: "camera"), makeButton(named: "file"),.flexibleSpace]
//    messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
    messageInputBar.isHidden = true
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let dataSource = messagesCollectionView.messagesDataSource else { return UICollectionViewCell() }
    
    let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
    switch message.kind {
      case .custom(let tempType):
        guard let type = tempType as? (String, NSMutableAttributedString) else { fallthrough }
        return generateCell(type: type.0, indexPath: indexPath, message: message, collection: messagesCollectionView)
      default:
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
  }
  
  private func generateCell(type: String, indexPath: IndexPath, message: MessageType, collection: MessagesCollectionView) -> UICollectionViewCell {
    switch type {
      case "finish":
        let cell = messagesCollectionView.dequeueReusableCell(FinishNowCC.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: collection)
        cell.finishDelegate = self
        return cell
      default:
       return UICollectionViewCell()
    }
  }
  
//  @objc func didTapFinishNow(_ sender: UIButton) {
//    print("didTapFinishNow")
//  }
  
}

extension NewChatVC: FinishNowCCDelegate {
  func didTapFinishNow() {
    print("didTapFinishNow")
  }
  
  
}


extension NewChatVC: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    guard text != "" else { return }
    
    inputBar.inputTextView.text = ""
    //    inputBar.contentView = CustomInputBar()

    inputBar.backgroundColor = .appColor(.lgr1)
    inputBar.inputTextView.backgroundColor = .appColor(.whiteTwo)
    inputBar.inputTextView.placeholder = "Message.."
    inputBar.inputTextView.font = UIFont(name: "NanumSquareR", size: 14.i)
    

//    inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
    inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 0, left: 15.i, bottom: 0, right: 0)
    
    //        processInputBar(inputBar)
    DatabaseManager.shared.sendMessage(text: text, chatID: chatID)
  }
  
  
  func processInputBar(_ inputBar: InputBarAccessoryView) {
    // Here we can parse for which substrings were autocompleted
    let attributedText = inputBar.inputTextView.attributedText!
    let range = NSRange(location: 0, length: attributedText.length)
    attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
      
      let substring = attributedText.attributedSubstring(from: range)
      let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
      print("Autocompleted: `", substring, "` with context: ", context ?? [])
    }
    
    let components = inputBar.inputTextView.components
    inputBar.inputTextView.text = String()
    inputBar.invalidatePlugins()
    // Send button activity animation
    inputBar.sendButton.startAnimating()
    inputBar.inputTextView.placeholder = "Sending..."
    // Resign first responder for iPad split view
    inputBar.inputTextView.resignFirstResponder()
    DispatchQueue.global(qos: .default).async {
      // fake send request task
      sleep(1)
      DispatchQueue.main.async { [weak self] in
        inputBar.sendButton.stopAnimating()
        inputBar.inputTextView.placeholder = "Aa"
        //              self?.insertMessages(components)
        //              self?.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
  }
  
  

}

extension NewChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
    return customMessageSizeCalculator ?? CustomMessageSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
  }
  
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
  
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    if message.sender.senderId == selfSender?.senderId {
      return 0
    } else {
      return 12.i
    }
  }
  
  func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    guard message.sender.senderId != selfSender?.senderId else { return nil }
    guard indexPath.section == self.messageLog.count - 1 else { return nil }
    let trans = self.messageLog[indexPath.section].translated
    let attach = NSTextAttachment()
    let img = UIImage(named: trans ? "translateOff" : "translateOn")
    
    attach.image = img
    attach.bounds = CGRect(x: 0, y: 0, width: 20.i, height: 20.i)
    
    let attachStr = NSAttributedString(attachment: attach)
    
    let attri = NSMutableAttributedString(string: " 번역하기")
    let font = UIFont(name: "NanumSquareB", size: 11.i) ?? UIFont()

    attri.addAttribute(.font, value: font, range: NSRange(location: 0, length: " 번역하기".count))
    let setColor = trans ? UIColor.appColor(.gr1) : UIColor.appColor(.aPp)
    attri.addAttribute(.foregroundColor, value: setColor, range: NSRange(location: 0, length: " 번역하기".count))
    attri.addAttribute(.baselineOffset, value: 5.i, range: NSRange(location: 0, length: " 번역하기".count))
    
    attri.insert(attachStr, at: 0)

    return attri
  }
  
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    guard indexPath.section == self.messageLog.count - 1 else { return 0 }
    guard message.sender.senderId != selfSender?.senderId else { return 0 }
    return 20.i
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
    messageInputBar.sendButton.frame = CGRect(x: 0, y: 0, width: 30.i, height: 30.i)
    messageInputBar.sendButton.image = UIImage(named: "send")
    messageInputBar.sendButton.setTitle(nil, for: .normal)
    messageInputBar.tintColor = .appColor(.perryWinkle)     // rightStackView color?
    messageInputBar.inputTextView.layer.borderWidth = CGFloat(0.5).iOS
    messageInputBar.inputTextView.layer.cornerRadius = 8.i
    messageInputBar.inputTextView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45.i)
    messageInputBar.inputTextView.placeholder = "Message.."
    messageInputBar.rightStackView.frame = CGRect(x: 8, y: 0, width: 30.i, height: 30.i)
    

    
    messageInputBar.frame = CGRect(x: 0, y: 0, width: 0, height: 45.i)
    messageInputBar.inputTextView.layer.borderColor = UIColor.appColor(.lgr4).cgColor
    messageInputBar.inputTextView.backgroundColor = .appColor(.whiteTwo)
    messageInputBar.backgroundView.backgroundColor = .appColor(.lgr1)
    messageInputBar.layer.borderColor = UIColor.clear.cgColor
    
    return message.sender.senderId == selfSender?.senderId ? .custom(outGoing) : .custom(inComming)
  }

  func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    accessoryView.subviews.forEach {
      $0.snp.removeConstraints()
      $0.removeFromSuperview()
    }
    let dateString = message.sentDate.toTimeString(date: message.sentDate)
    let attri = NSMutableAttributedString(string: dateString)
    let font = UIFont(name: "NanumSquareR", size: 9.i) ?? UIFont()
    
    attri.addAttribute(.font, value: font, range: NSRange(location: 0, length: dateString.count))
    attri.addAttribute(.foregroundColor, value: UIColor.appColor(.gr1), range: NSRange(location: 0, length: dateString.count))
    
    let timeLabel = UILabel()
    let unreadCount = UILabel()
    unreadCount.text = "1"
    unreadCount.textColor = .appColor(.aPp)
    unreadCount.font = font
    
    timeLabel.attributedText = attri
    
    accessoryView.addSubview(timeLabel)
    accessoryView.addSubview(unreadCount)
    
    timeLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      if message.sender.senderId == selfSender?.senderId {
        $0.trailing.equalToSuperview().inset(7.i)
      } else {
        $0.leading.equalToSuperview().inset(7.i)
      }
    }
    
    unreadCount.snp.makeConstraints {
      $0.bottom.equalTo(timeLabel.snp.top).offset(-3.i)
      if message.sender.senderId == selfSender?.senderId {
        $0.trailing.equalToSuperview().inset(7.i)
      } else {
        $0.leading.equalToSuperview().inset(7.i)
      }
    }
    
//    let width = 44.i
//    let lowHeight = 25.i
//    let highHeight = 50.i
//    let me = message.sender.senderId == selfSender?.senderId
//    let x = me ? accessoryView.frame.origin.x - width : accessoryView.frame.origin.x
    
    guard indexPath.section != self.messageLog.count - 1 else {
//      accessoryView.frame = CGRect(origin: CGPoint(x: x,
//                                                   y: accessoryView.frame.origin.y - lowHeight),
//                                   size: CGSize(width: width, height: lowHeight))
      return }
    if self.messageLog[indexPath.section].translated {
//      accessoryView.frame = CGRect(origin: CGPoint(x: accessoryView.frame.origin.x,
//                                                   y: accessoryView.frame.origin.y - highHeight),
//                                   size: CGSize(width: width, height: highHeight))
      let iv = UIImageView(image: UIImage(named: "translateOff"))
//      let transOffBtn = UIButton(type: .custom)
//      transOffBtn.setImage(UIImage(named: "translateOff"), for: .normal)
//      transOffBtn.addTarget(self, action: #selector(didTapTransOffBtn(_:)), for: .touchUpInside)
//      transOffBtn.tag = indexPath.section
//      transOffBtn.contentMode = .scaleAspectFill
//      transOffBtn.imageEdgeInsets = UIEdgeInsets(top: 8.i, left: 11.i, bottom: 14.i, right: 11.i)
      
//      accessoryView.isUserInteractionEnabled = true
      accessoryView.addSubview(iv)
      accessoryView.frame.size = CGSize(width: 44.i, height: -50.i)
      
      iv.snp.makeConstraints {
        $0.centerX.equalTo(timeLabel)
        $0.bottom.equalTo(unreadCount.snp.top)
        $0.width.height.equalTo(23.i)
      }
    }
    
  }
  
}

extension NewChatVC: MessageCellDelegate {
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    let log = messageLog[indexPath.section]
    avatarView.isHidden = log.sender.senderId == selfSender?.senderId
  }
  
  func didTapMessage(in cell: MessageCollectionViewCell) {
    guard let idx = self.messagesCollectionView.indexPath(for: cell) else { return }
    guard !self.messageLog[idx.section].translated else { return }
    guard self.messageLog[idx.section].sender.senderId != self.selfSender?.senderId else { return }
    self.messageLog[idx.section].toggleTrans {
      self.messagesCollectionView.reloadDataAndKeepOffset()
    }
    
  }
  
  func didTapAccessoryView(in cell: MessageCollectionViewCell) {
    print("didTapAccessoryView")
    guard let idx = self.messagesCollectionView.indexPath(for: cell) else { return }
    guard self.messageLog[idx.section].translated else { return }
    self.messageLog[idx.section].toggleTrans {
      self.messagesCollectionView.reloadDataAndKeepOffset()
    }
  }
  
//  @objc private func didTapTransOffBtn(_ sender: UIButton) {
//    print("didTapTransOffBtn")
//    guard self.messageLog[sender.tag].translated else { return }
//    self.messageLog[sender.tag].toggleTrans {
//      self.messagesCollectionView.reloadDataAndKeepOffset()
//    }
//  }
  
}
