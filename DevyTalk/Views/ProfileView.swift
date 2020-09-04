//
//  ProfileView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class ProfileView: UIView {
  
  lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.backgroundColor = .clear
    tb.separatorStyle = .none
    tb.isScrollEnabled = true
    tb.showsVerticalScrollIndicator = false
    tb.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
    tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.i, right: 0)
    return tb
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [tableView].forEach {
      self.addSubview($0)
    }
  }
  
  
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  
}
