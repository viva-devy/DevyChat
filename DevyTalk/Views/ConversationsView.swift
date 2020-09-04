//
//  ConversationsView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class ConversationsView: UIView {
  
  lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.isHidden = true
    tb.backgroundColor = .clear
    tb.isScrollEnabled = true
    tb.showsVerticalScrollIndicator = false
    tb.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier)
    tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.i, right: 0)
    return tb
  }()
  // scrollsToLastItemOnKeyboardBeginsEditing
  let noConversationsLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.text = "No Conversations"
    label.font = UIFont(name: "NanumSquareB", size: 21.i)
    label.textColor = .appColor(.gr1)
    label.textAlignment = .center
    return label
  }()
  
   
   override func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.backgroundColor = .white
     addSubViews()
     setupSNP()
   }
   
   private func addSubViews() {
     [tableView, noConversationsLabel].forEach {
       self.addSubview($0)
     }
   }
   
   
   private func setupSNP() {
     tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
     }
    
    noConversationsLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(50.i)
    }
    
   }
  
}
