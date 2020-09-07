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

protocol ButtonCell: class {
  var btn: UIButton { get }
}

class FinishNowCC: UICollectionViewCell, ButtonCell {
  let btn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = .appColor(.aPp, alpha: 0.2)
    btn.setTitle("Finish now", for: .normal)
    btn.setTitleColor(.appColor(.aPp), for: .normal)
    return btn
  }()
  
  let contentLabel: UILabel = {
    let label = UILabel()
    label.text = "Your non-face-to-face treatment is over. Were you satisfied with our service? If there is no response within 24 hours, this chat will end automatically!"
    label.numberOfLines = 0
    return label
  }()
  
  func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
    self.contentView.backgroundColor = .appColor(.whiteTwo)
    self.btn.tag = indexPath.section
    addSubviews()
    setupSNP()
  }
  
  private func addSubviews() {
    [btn, contentLabel].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  private func setupSNP() {
    contentLabel.snp.makeConstraints {
      $0.width.equalTo(224.i)
      $0.centerX.equalToSuperview()
//      $0.leading.trailing.equalToSuperview().inset(11.i)
      $0.top.equalToSuperview().offset(9.i)
    }
    
    btn.snp.makeConstraints {
      $0.width.equalTo(224.i)
      $0.top.equalTo(contentLabel.snp.bottom).offset(20.i)
      $0.centerX.equalToSuperview()
//      $0.leading.trailing.equalToSuperview().inset(11.i)
      $0.bottom.equalToSuperview().offset(-9.i)
      
    }
  }
  
  
  
  
}
