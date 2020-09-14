//
//  LanguageSettingView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class LanguageSettingView: UIView {
 
  lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.backgroundColor = .clear
    tb.separatorStyle = .none
    tb.isScrollEnabled = true
    tb.showsVerticalScrollIndicator = false
    tb.register(LanguageSettingCell.self, forCellReuseIdentifier: LanguageSettingCell.identifier)
    tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.i, right: 0)
    return tb
  }()
  
  let completeBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Save", for: .normal)
    btn.titleLabel?.textAlignment = .center
    btn.backgroundColor = .appColor(.aPk)
    btn.setTitleColor(UIColor.appColor(.whiteTwo), for: .normal)
    btn.titleLabel?.font = UIFont(name: "NanumSquareB", size: 15.i)
    return btn
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    [tableView, completeBtn]
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    completeBtn.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-CGFloat(54).iOS)
    }
//    completeBtn.titleLabel?.snp.makeConstraints {
//      $0.centerY.equalToSuperview().offset(UIDevice().hasNotch ? -UIScreen.main.bounds.width * 0.023 : 6)
//      $0.centerX.equalToSuperview()
//    }
    
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(completeBtn.snp.top)
    }
  }
}
