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
  
  open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
      guard let layout = layout else { return .zero }
      let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
      let contentInset = layout.collectionView?.contentInset ?? .zero
      let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
      return CGSize(width: 247.i, height: 168.i)
  }
//  open override func messageContainerSize(for message: MessageType) -> CGSize {
//    switch message.kind {
//      case .custom(let tempType):
//        guard let type = tempType as? String else { return .zero }
//        switch type {
//          case "finish":
//            return CGSize(width: 247.i, height: 168.i)
//          default:
//            return super.messageContainerSize(for: message)
//      }
//      default:
//        return super.messageContainerSize(for: message)
//    }
//  }
}
