//
//  CustomMessagesSizeCalculator.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/06.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import MessageKit

open class CustomMessageSizeCalculator: MessageSizeCalculator {
  public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
      super.init()
      self.layout = layout
  }
  
//  open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
//      guard let layout = layout else { return .zero }
//      let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
//      let contentInset = layout.collectionView?.contentInset ?? .zero
//      let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
//      return CGSize(width: 247.i, height: 168.i)
//  }
  open override func messageContainerSize(for message: MessageType) -> CGSize {
    switch message.kind {
      case .custom(let tempType):
        guard let item = tempType as? (String, NSMutableAttributedString) else { return .zero }
        let type = item.0
        switch type {
          case "finish":
            // Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!
//            let attri = NSMutableAttributedString(string: "Your non-face-to-face treatment is over. Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!")
//            let font = UIFont(name: "NanumSquareR", size: 13.i)!
//            attri.addAttribute(.font, value: font, range: NSMakeRange(0, attri.length))
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 6.i
//            attri.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attri.length))
            let maxWidth = 247.i
//            print("maxWidth: ", maxWidth)
            let tempSize = labelSize(for: item.1, considering: maxWidth - 10.i - 10.i)
            print("tempSize: ", tempSize)
            return CGSize(width: maxWidth, height: tempSize.height + 20.i + 35.i + 10.i + 10.i)
//            return CGSize(width: maxWidth, height: 168.i)
          default:
            return super.messageContainerSize(for: message)
      }
      default:
        return super.messageContainerSize(for: message)
    }
  }
}
