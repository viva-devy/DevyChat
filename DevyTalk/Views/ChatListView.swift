//
//  CheckListView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class ChatListView: UIView {
  
  lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.separatorStyle = .none
    tb.backgroundColor = .clear
    tb.isScrollEnabled = true
    tb.showsVerticalScrollIndicator = false
    tb.contentInset = UIEdgeInsets(top: 10.i, left: 0, bottom: 50.i, right: 0)
    tb.register(WaitingInfoCell.self, forCellReuseIdentifier: WaitingInfoCell.identifier)
    tb.register(AppointmentCell.self, forCellReuseIdentifier: AppointmentCell.identifier)
    tb.register(BasicWaitingCell.self, forCellReuseIdentifier: BasicWaitingCell.identifier)
    tb.register(InfoWaitingCell.self, forCellReuseIdentifier: InfoWaitingCell.identifier) 
    tb.register(GlobalWaitingCell.self, forCellReuseIdentifier: GlobalWaitingCell.identifier)
    tb.clipsToBounds = true
    return tb
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    [tableView]
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }

}
