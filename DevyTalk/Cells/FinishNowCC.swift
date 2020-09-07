//
//  FinishNowCC.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/06.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import MessageKit

//protocol ButtonCell: class {
//  var btn: UIButton { get }
//}
//
//class FinishNowCC: UICollectionViewCell, ButtonCell {
//  let btn: UIButton = {
//    let btn = UIButton()
//    btn.backgroundColor = .appColor(.aPp, alpha: 0.2)
//    btn.setTitle("Finish now", for: .normal)
//    btn.setTitleColor(.appColor(.aPp), for: .normal)
//    return btn
//  }()
//
//  let contentLabel: UILabel = {
//    let label = UILabel()
//    label.text = "Your non-face-to-face treatment is over. Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!"
//    label.numberOfLines = 0
//    return label
//  }()
//
//  func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
//    self.contentView.backgroundColor = .appColor(.whiteTwo)
//    self.btn.tag = indexPath.section
//    addSubviews()
//    setupSNP()
//  }
//
//  private func addSubviews() {
//    [btn, contentLabel].forEach {
//      self.contentView.addSubview($0)
//    }
//  }
//
//  private func setupSNP() {
//    contentLabel.snp.makeConstraints {
//      $0.width.equalTo(224.i)
//      $0.centerX.equalToSuperview()
////      $0.leading.trailing.equalToSuperview().inset(11.i)
//      $0.top.equalToSuperview().offset(9.i)
//    }
//
//    btn.snp.makeConstraints {
//      $0.width.equalTo(224.i)
//      $0.top.equalTo(contentLabel.snp.bottom).offset(20.i)
//      $0.centerX.equalToSuperview()
////      $0.leading.trailing.equalToSuperview().inset(11.i)
//      $0.bottom.equalToSuperview().offset(-9.i)
//
//    }
//  }
//}

protocol FinishNowCCDelegate: class {
  func didTapFinishNow()
}

/// A subclass of `MessageContentCell` used to display text messages.
class FinishNowCC: MessageContentCell {
  
  // MARK: - Properties
  
  /// The `MessageCellDelegate` for the cell.
  //    override weak var delegate: MessageCellDelegate? {
  //        didSet {
  //            messageLabel.delegate = delegate
  //        }
  //    }
  
  /// The label used to display the message's text.
  //    var messageLabel = MessageLabel()
  weak var finishDelegate: FinishNowCCDelegate?
  
  let btn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = .appColor(.aPp, alpha: 0.2)
    btn.setTitle("Finish now", for: .normal)
    btn.setTitleColor(.appColor(.aPp), for: .normal)
    btn.layer.cornerRadius = 6.i
    btn.layer.borderWidth = 1
    btn.layer.borderColor = UIColor.appColor(.aPp, alpha: 0.75).cgColor
    return btn
  }()
  //
  let contentLabel: UILabel = {
    let label = UILabel()
    let attri = NSMutableAttributedString(string: "Your non-face-to-face treatment is over. Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!")
    let font = UIFont(name: "NanumSquareR", size: 13.i)!
    attri.addAttribute(.font, value: font, range: NSMakeRange(0, attri.length))
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6.i
    attri.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attri.length))
    label.attributedText = attri
    label.numberOfLines = 0
    return label
  }()
  
  // MARK: - Methods
  
      override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
          super.apply(layoutAttributes)
//          if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
//              messageLabel.textInsets = attributes.messageLabelInsets
//              messageLabel.messageLabelFont = attributes.messageLabelFont
//  //            messageLabel.frame = messageContainerView.bounds
//            messageLabel.frame = CGRect(origin: messageContainerView.bounds.origin, size: CGSize(width: messageContainerView.bounds.width, height: messageContainerView.bounds.height - 65.i))

//          }
      }
  
  //    override func prepareForReuse() {
  //        super.prepareForReuse()
  //        messageLabel.attributedText = nil
  //        messageLabel.text = nil
  //    }
  
  override func setupSubviews() {
    super.setupSubviews()
    messageContainerView.addSubview(contentLabel)
    messageContainerView.addSubview(btn)
  }
  
  private func setupSNP() {
      contentLabel.snp.makeConstraints {
//        $0.width.equalTo(224.i)
        $0.centerX.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(10.i)
        $0.top.equalToSuperview().offset(10.i)
      }

      btn.snp.makeConstraints {
//        $0.width.equalTo(224.i)
        $0.top.equalTo(contentLabel.snp.bottom).offset(20.i)
        $0.centerX.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(10.i)
//        $0.bottom.equalToSuperview().offset(-9.i)

      }
    }
  
  override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
    super.configure(with: message, at: indexPath, and: messagesCollectionView)
    if let attri = messagesCollectionView.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes {
      print("here")
      print(attri.avatarPosition.vertical)
      self.apply(attri)
    }
    
    switch message.kind {
      case .custom(let value):
        guard let item = value as? (String, NSMutableAttributedString) else { return }
        contentLabel.attributedText = item.1
      default:
        break
    }
    
    
    setupSNP()
    //    guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
    //      fatalError("MessagesDisplayDelegate has not been set.")
    //    }
    
//    let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
//
//    messageLabel.configure {
//      messageLabel.enabledDetectors = enabledDetectors
//      for detector in enabledDetectors {
//        let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
//        messageLabel.setAttributes(attributes, detector: detector)
//      }
//      switch message.kind {
//        case .text(let text), .emoji(let text):
//          let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
//          messageLabel.text = text
//          messageLabel.textColor = textColor
//          if let font = messageLabel.messageLabelFont {
//            messageLabel.font = font
//        }
//        case .attributedText(let text):
//          messageLabel.attributedText = text
//        default:
//          break
//      }
//    }
  }
  
  /// Used to handle the cell's contentView's tap gesture.
  /// Return false when the contentView does not need to handle the gesture.
  override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
    if btn.frame.contains(touchPoint) {
      finishDelegate?.didTapFinishNow()
      return true
    } else {
      return false
    }
  }
  
}

