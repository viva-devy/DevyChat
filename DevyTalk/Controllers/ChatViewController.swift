//
//  ChatViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
import AVFoundation
import AVKit

class ChatViewController: MessagesViewController {
  
  public static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .long
    formatter.locale = .current
    return formatter
  }()
  
  public let otherUserEmail: String
  public let conversationId: String?
  public var isNewConversation: Bool = false
  
  private var messages = [Message]()
  
  var selfSender: Sender? {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
      return nil
    }
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    
    return Sender(senderId: safeEmail, displayName: "Me")
  }
  
  
  init(with email: String, id: String?) {
    self.conversationId = id
    self.otherUserEmail = email
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    setupNavi()
    
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
    messageInputBar.delegate = self
    
    setupInputButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    messageInputBar.inputTextView.becomeFirstResponder()
    
    if let conversationId = conversationId {
      
      listenForMessages(id: conversationId, shouldScrollToBottom: true)
      
    }
  }
  
  private func setupInputButton() {
    let button = InputBarButtonItem()
    button.setSize(CGSize(width: 35.i, height: 35.i), animated: false)
    button.setTitle("+", for: .normal)
    button.setTitleColor(.appColor(.dark), for: .normal)
    button.onTouchUpInside { [weak self] _ in
      self?.presentInputActionSheet()
    }
    messageInputBar.setLeftStackViewWidthConstant(to: 36.i, animated: false)
    messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    
  }
  
  private func presentInputActionSheet() {
    let actionSheet = UIAlertController(title: "Attach Media",
                                        message: "what would you like to attach",
                                        preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
      
      self?.presentPhotoInputActionsheet()
    }))
    actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self] _ in
      self?.presentVideoInputActionsheet()
    }))
    actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: { _ in
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(actionSheet, animated: true, completion: nil)
    
  }
  
  private func presentPhotoInputActionsheet() {
    let actionSheet = UIAlertController(title: "Attach Photo",
                                        message: "Where would you like to attach a photo from",
                                        preferredStyle: .actionSheet)
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
  
  private func presentVideoInputActionsheet() {
    let actionSheet = UIAlertController(title: "Attach Video",
                                        message: "Where would you like to attach a Video from?",
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.delegate = self
      picker.mediaTypes = ["public.movie"]
      picker.videoQuality = .typeMedium
      picker.allowsEditing = true
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
      
      let picker = UIImagePickerController()
      picker.sourceType = .photoLibrary
      picker.delegate = self
      picker.allowsEditing = true
      picker.mediaTypes = ["public.movie"]
      picker.videoQuality = .typeMedium
      self?.present(picker, animated: true)
      
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(actionSheet, animated: true)
  }
  
  
  private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
    
    DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
      switch result {
      case .success(let messages):
        
        guard !messages.isEmpty else {
          
          return
        }
        self?.messages = messages
        
        DispatchQueue.main.async {
          self?.messagesCollectionView.reloadDataAndKeepOffset()
          
          if shouldScrollToBottom {
            self?.messagesCollectionView.scrollToBottom()
          }
        }
      case .failure(_):
        ()
      }
    })
  }
  
  
  private func setupNavi() {
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 35.i) ?? UIFont()]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.aBk)]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
    
  }
  
  
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true, completion: nil)
    guard let messageId = createMessageID(),
      let conversationId = conversationId,
      let name = self.title,
      let selfSender = selfSender else {
        return
    }
    
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = image.pngData() {
      // 여기는 포토포토
      let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
      
      // upload image
      StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
        guard let strongSelf = self else {
          return
        }
        
        switch result {
        case .success(let urlString):
          // Ready to send message
          
          
          guard let url = URL(string: urlString),
            let placeholder = UIImage(named: "picADD") else {
              return
          }
          
          let media = Media(url: url,
                            image: nil,
                            placeholderImage: placeholder,
                            size: .zero)
          
          let message = Message(sender: selfSender,
                                messageId: messageId,
                                sentDate: Date(),
                                kind: .photo(media))
          
          DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
            
            if success {
              
            }
            else {
              
            }
            
          })
        // Ready to send message
        case .failure(_):
          ()
        }
      })
    } else if let videoUrl = info[.mediaURL] as? URL {
      // 여기는 비디오
      let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
      // Upload video
      
      StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
        guard let strongSelf = self else {
          return
        }
        
        switch result {
        case .success(let urlString):
          // Ready to send message
          
          
          guard let url = URL(string: urlString),
            let placeholder = UIImage(named: "picADD") else {
              return
          }
          
          let media = Media(url: url,
                            image: nil,
                            placeholderImage: placeholder,
                            size: .zero)
          
          let message = Message(sender: selfSender,
                                messageId: messageId,
                                sentDate: Date(),
                                kind: .video(media))
          
          DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
            
            if success {
              
            }
            else {
              
            }
            
          })
          
        case .failure(_):
          ()
        }
      })
    }
    
    
  }
  
  
}

extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
      let selfSender = self.selfSender,
      let messageId = createMessageID() else {
        return
    }
    
    
    
    let message = Message(sender: selfSender,
                          messageId: messageId,
                          sentDate: Date(),
                          kind: .text(text))
    
    // send massage
    if isNewConversation {
      // create convo in database
      DatabaseManager.shared.createnewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: { [weak self] success in
        if success {
          let newConversationId = "conversation_\(message.messageId)"
          self?.isNewConversation = false
          self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
        } else {
          
        }
      })
    } else {
      guard let conversationId = conversationId, let name = self.title else {
        return
      }
      // append to existing conversation  data
      DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message,  completion: { success in
        if success {
          
        } else {
          
        }
        
      })
    }
    
  }
  
  private func createMessageID() -> String? {
    // date, otherUserEmail, senderEmail, randomInt
    
    guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
      return nil
    }
    
    let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
    
    let dateString = ChatViewController.self.dateFormatter.string(from: Date())
    let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
    
    
    return newIdentifier
    
  }
  
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func currentSender() -> SenderType {
    if let sender = selfSender {
      return sender
    }
    
    fatalError("Self Sender is nil, email should be cached")
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    messageInputBar.resignFirstResponder()
  }
  
  func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    guard let message = message as? Message else {
      return
    }
    
    switch message.kind {
    case .photo(let media):
      guard let imageUrl = media.url else {
        return
      }
      imageView.sd_setImage(with: imageUrl, completed: nil)
    default:
      break
    }
    
  }
  
  
}

extension ChatViewController: MessageCellDelegate {
  func didTapImage(in cell: MessageCollectionViewCell) {
    guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
      return
    }
    
    let message = messages[indexPath.section]
    
    switch message.kind {
    case .photo(let media):
      guard let imageUrl = media.url else {
        return
      }
      let photoVC = PhotoViewViewController(with: imageUrl)
      self.navigationController?.pushViewController(photoVC, animated: true)
    case .video(let media):
      guard let videoUrl = media.url else {
        return
      }
      
      let avPlayerVC = AVPlayerViewController()
      avPlayerVC.player = AVPlayer(url: videoUrl)
      present(avPlayerVC, animated: true)
    default:
      break
    }
  }
  
}

