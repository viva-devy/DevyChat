//
//  CustomMessageFlowLayout.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/06.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import MessageKit

open class CustomMessageFlowLayout: MessagesCollectionViewFlowLayout {
  open lazy var calculator = CustomMessageSizeCalculator(layout: self)
  
  open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
    if isSectionReservedForTypingIndicator(indexPath.section) {
        return typingIndicatorSizeCalculator
    }
    let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
    if case .custom = message.kind {
      return calculator
    }
    return super.cellSizeCalculatorForItem(at: indexPath)
  }
  
  open override func messageSizeCalculators() -> [MessageSizeCalculator] {
    var superCalculators = super.messageSizeCalculators()
    // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
    // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
    superCalculators.append(calculator)
    return superCalculators
  }
}
