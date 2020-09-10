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
  
  var isSelect: Bool = false
  
  var hosData: (String, String) = ("", "")        //(chatUser.hosID ?? "hosID", chatUser.hosNAME ?? "hosName")
  
  var messageLog: [BasicMessageModel] = [] {      // 메세지 보낸 기록이 있는 화면
    didSet {
      DispatchQueue.main.async {
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
        self.messageInputBar.inputTextView.becomeFirstResponder()
        self.configureMessageInputBar()
        //        self.setupInputButton()
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
    checkFirst()
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
    DatabaseManager.shared.checkReadSign(id: chatID)
  }
  
  private func convertToMessageLog(_ origin: [String: Any]) -> BasicMessageModel {
    let id = origin["m_chatid"] as? String
//    let delta = (origin["m_messageDate"] as? [String: Any])?["time"] as? Int ?? 0
//    let offset = (origin["m_messageDate"] as? [String: Any])?["timezoneOffset"] as? Int ?? 0
    let date = origin["m_messageDate"] as? [String: Any] ?? [:]
    let messageId = origin["m_messageId"] as? String
    let type = origin["m_messageType"] as? String
    let user = try? UserData(dictionary: (origin["m_messageUser"] as? [String: Any]) ?? [:])
    // [String: Any]타입의 딕셔너리로 Userdata를 생성한다.
    let list = origin["m_readUserList"] as? [String]
    let unread = origin["m_unreadCount"] as? Int
    let message = origin["message"] as? String
    let tm = origin["tm_int"] as? Int
//    print(message, delta, offset)
    return TextMessageModel(ID: id ?? "", date: toDate(data: date), messageId: messageId ?? "", type: type ?? "", user: user ?? UserData(), list: list ?? [], unread: unread ?? 0, message: message ?? "", tmInt: tm ?? 0)
  }
  
  func toDate(data: [String: Any]) -> Date {
    guard let messageDate = try? JSONDecoder().decode(MessageDate.self, from: JSONSerialization.data(withJSONObject: data)) else { return Date() }
    guard let messageTZ = TimeZone(secondsFromGMT: -(messageDate.timezoneOffset * 60))
      else { return Date() }
    
    let formatter = DateFormatter()
    formatter.timeZone = messageTZ
    formatter.dateFormat = "yyyyMMddHHmmss"
    let mDateStr = "\(messageDate.year + 1900)" + messageDate.month.fillZero() + messageDate.date.fillZero() + messageDate.hours.fillZero() + messageDate.minutes.fillZero() + messageDate.seconds.fillZero()
    let mDate = formatter.date(from: mDateStr) ?? Date()
    
    return Calendar.current.dateBySetting(timeZone: TimeZone.autoupdatingCurrent, of: mDate) ?? Date()
  }
  
  
  
  
  
  // 보낸기록이 있는지 확인
  private func getChatLog(chatID: String, completion: @escaping ([String: [String: Any]]) -> ()) {
    DatabaseManager.shared.getChatLog(id: chatID, completion: completion)
  }
  
  private func checkFirst() {
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
    messageInputBar.separatorLine.isHidden = true
    //    messageInputBar.inputTextView.frame = CGRect(x: 45.i, y: 0, width: 320.i, height: 45.i)
    print("messageInputBar.inputTextView.frame: ", messageInputBar.inputTextView.frame)
    
    
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
  
  func configureMessageInputBar() {
    messageInputBar.middleContentViewPadding = UIEdgeInsets(top: 0.i, left: 0.i, bottom: 0.i, right: 10.i)
    messageInputBar.middleContentView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65.i)
    messageInputBar.separatorLine.isHidden = true
    messageInputBar.inputTextView.tintColor = .appColor(.aPk)
    messageInputBar.inputTextView.backgroundColor = .appColor(.whiteTwo)
    //
    messageInputBar.inputTextView.contentInset = UIEdgeInsets(top: 0.i, left: 0.i, bottom: 0, right: 10.i)
    
    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 12.i, left: 10.i, bottom: 12.i, right: 2.i)
    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 12.i, left: 7.i, bottom: 12.i, right: 2.i)
    
    
    messageInputBar.inputTextView.layer.borderColor = UIColor.appColor(.lgr4).cgColor
    messageInputBar.inputTextView.layer.borderWidth = CGFloat(0.5).iOS
    messageInputBar.inputTextView.layer.cornerRadius =  8.i
    messageInputBar.inputTextView.layer.masksToBounds = true
    messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    configureInputBarItems()
  }
  
  
  private func configureInputBarItems() {
    setupInputButton()
    messageInputBar.setRightStackViewWidthConstant(to: 38.i, animated: false)
    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0.i, left: 0.i, bottom: 0.i, right: 0.i)
    messageInputBar.sendButton.setSize(CGSize(width: 36.i, height: 36.i), animated: false)
    messageInputBar.sendButton.contentMode = .scaleAspectFill
    messageInputBar.sendButton.image = #imageLiteral(resourceName: "send")
    messageInputBar.sendButton.title = nil
    let charCountButton = InputBarButtonItem()
      .onTextViewDidChange { (item, textView) in
        item.title = ""
        textView.layer.cornerRadius = 8.i
    }
    let bottomItems = [.flexibleSpace, charCountButton]
    
    configureInputBarPadding()
    
    messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
    
  }
  
  
  private func configureInputBarPadding() {
    // Entire InputBar padding 전체 InputBar 패딩 - send버튼이랑 글자 사이 간격
    messageInputBar.padding.bottom = 8.i
    
    // or MiddleContentView padding 또는 MiddleContentView 패딩
    messageInputBar.middleContentViewPadding.right = -40.i
    messageInputBar.middleContentViewPadding.bottom = -20.i
    messageInputBar.middleContentViewPadding.left = 8.i
    
    // or InputTextView padding 또는 InputTextView 패딩 - 텍스트 바텀
    messageInputBar.inputTextView.textContainerInset.bottom = 12.i
    messageInputBar.sendButton.imageEdgeInsets.bottom = 7.i
    messageInputBar.sendButton.contentMode = .scaleAspectFill
    
  }
  
  private func setupInputButton() {
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.leftStackView.isUserInteractionEnabled = true
    let button = InputBarButtonItem()
    button.imageEdgeInsets = UIEdgeInsets(top: 0.i, left: 0, bottom: 0.i, right: 5.i)
    button.setSize(CGSize(width: 40.i, height: 40.i), animated: false)
    button.setImage(UIImage(named: "add"), for: .normal)
    button.onTouchUpInside { [weak self] btn in
      btn.isSelected.toggle()
      if btn.isSelected {
        self?.configureMessageInputBarForChat(btn)
      } else {
        self?.hideMessageInputBarForChat(btn)
      }
    }

    
    messageInputBar.setLeftStackViewWidthConstant(to: 25.i, animated: false)
    messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    
  }
  
  // add버튼 눌렀을때 action
  @objc private func configureMessageInputBarForChat(_ sender: UIButton) {
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
    
    let bottomItems = [makeButton(named: "album"), makeButton(named: "camera"), makeButton(named: "file"), .flexibleSpace]
    
    messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
    messageInputBar.sendButton.backgroundColor = .clear
    bottomItems[0].onTouchUpInside { [weak self] _ in
      self?.didTapAlbumIV()
    }
    bottomItems[1].onTouchUpInside { [weak self] _ in
      self?.didTapCameraIV()
    }
    bottomItems[2].onTouchUpInside { [weak self] _ in
      self?.didTapFileIV()
    }
    
  }
  
  // 3개 버튼
  private func makeButton(named: String) -> InputBarButtonItem {
    return InputBarButtonItem()
      .configure {
        messageInputBar.middleContentViewPadding.bottom = 15.i
        $0.spacing = .fixed(55.i)
        $0.titleEdgeInsets = UIEdgeInsets(top: 25.i, left: 0, bottom: 15.i, right: 0)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30.i, bottom: 0, right: 0)
        $0.backgroundColor = .clear
        $0.image = UIImage(named: named)
        $0.setSize(CGSize(width: 48.i, height: 70.i), animated: false)
        $0.sizeToFit()
    }
    .onTouchUpInside { _ in
      print("Item Tapped")
    }
  }
  
  @objc private func hideMessageInputBarForChat(_ sender: UIButton) {
    print("hide: ", sender.isSelected)
    
//    messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
    //    messageInputBar.setRightStackViewWidthConstant(to: 52, animated: false)
    //    let bottomItems = [makeButton(named: "album"), makeButton(named: "camera"), makeButton(named: "file"),.flexibleSpace]
    //    messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
//    messageInputBar.isHidden = true
//    self.isSelect = true
  }
  
  private func presentPhotoInputActionsheet() {
    let actionSheet = UIAlertController(title: "Attach Photo",
                                        message: "Where would you like to attach a photo from",
                                        preferredStyle: .alert)
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.delegate = self
      picker.allowsEditing = true
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .photoLibrary
      picker.delegate = self
      picker.allowsEditing = true
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(actionSheet, animated: true)
  }
  
  @objc func didTapAlbumIV() {
    print("didTapAlbumIV")
    let actionSheet = UIAlertController(title: "Attach Photo",
                                        message: "Where would you like to attach a photo from",
                                        preferredStyle: .alert)
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .photoLibrary
      picker.delegate = self
      picker.allowsEditing = true
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    
    present(actionSheet, animated: true)
    
  }
  
  @objc func didTapCameraIV() {
    print("didTapcameraIV")
    let actionSheet = UIAlertController(title: "Attach Photo",
                                        message: "Where would you like to attach a photo from",
                                        preferredStyle: .alert)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.delegate = self
      picker.allowsEditing = true
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    
    present(actionSheet, animated: true)
  }
  
  @objc func didTapFileIV() {
    print("didTapFileIV")
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
    inputBar.separatorLine.isHidden = true
    
    let attri = NSMutableAttributedString(string: inputBar.inputTextView.text)
    let font = UIFont.systemFont(ofSize: 14.i, weight: .regular)
    
    attri.addAttribute(.font, value: font, range: NSRange(location: 0, length: inputBar.inputTextView.text.count))
    attri.addAttribute(.foregroundColor, value: UIColor.appColor(.gr2), range: NSRange(location: 0, length: inputBar.inputTextView.text.count))
    
    
    DatabaseManager.shared.sendMessage(text: text, chatID: chatID)
  }
  
  
  
}

extension NewChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
    return customMessageSizeCalculator ?? CustomMessageSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
  }
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return .appColor(message.sender.senderId == selfSender?.senderId ? .perryWinkle : .whiteTwo)
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
    let font = UIFont.systemFont(ofSize: 14.i, weight: .regular)
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
    let setColor = trans ? UIColor.appColor(.gr1) : UIColor.appColor(.perryWinkle)
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
    
//    messageInputBar.tintColor = .appColor(.perryWinkle)
    messageInputBar.inputTextView.layer.borderWidth = CGFloat(0.5).iOS
    messageInputBar.inputTextView.layer.cornerRadius = 8.i
    messageInputBar.inputTextView.placeholder = " Message.."
    messageInputBar.inputTextView.placeholderTextColor = .appColor(.gr1)
    
    messageInputBar.inputTextView.layer.borderColor = UIColor.appColor(.lgr4).cgColor
    messageInputBar.inputTextView.backgroundColor = .appColor(.whiteTwo)
    messageInputBar.backgroundView.backgroundColor = .appColor(.lgr2)
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

extension NewChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("dismiss")
    picker.dismiss(animated: true, completion: nil)
  }
  
  
}
