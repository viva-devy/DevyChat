//
//  ProfileCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
  
  static let identifier = "ProfileCell"
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont(name: "NanumSquareB", size: 17.i)
    label.textColor = .appColor(.aBk)
    return label
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    [titleLabel]
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(17.i)
      $0.centerX.equalToSuperview()
    }
  }
  
  
}
