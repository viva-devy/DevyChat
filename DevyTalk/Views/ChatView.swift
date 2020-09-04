//
//  ChatView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class ChatView: UIView {
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    []
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    
  }
  
}
