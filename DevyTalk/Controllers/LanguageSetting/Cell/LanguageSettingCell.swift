//
//  LanguageSettingCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

protocol LanguageSettingCellDelegate: class {
  func didTapCheckItem(sender: UIButton)
}
class LanguageSettingCell: UITableViewCell {
  
  static let identifier = "LanguageSettingCell"
  
  weak var delegate: LanguageSettingCellDelegate?
  
  var feedData: String? {
    willSet(new) {
      guard let data = new else { return }
      titleLabel.text = data
    }
  }
  
  var indexPath: IndexPath = []
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .appColor(.aBk)
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.text = ""
    return label
  }()
  
  lazy var checkBtn: UIButton = {
    let btn = UIButton()
    btn.isEnabled = true
    btn.imageView?.contentMode = .scaleAspectFit
    btn.contentMode = .scaleAspectFit
    btn.setImage(UIImage(named: "iconChoiceOff"), for: .normal)
    btn.setImage(UIImage(named: "iconChoiceOn"), for: .selected)
    return btn
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    checkBtn.isSelected = false
    checkBtn.alpha = 1
  }
  
  @objc func didTapCheckBtn(_ sender: UIButton) {
    delegate?.didTapCheckItem(sender: sender)
  }
  
  private func addSubViews() {
    [titleLabel, checkBtn]
      .forEach { self.contentView.addSubview($0) }
  }
  
  private func setupSNP() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16.i)
      $0.leading.equalToSuperview().offset(25.i)
      $0.trailing.equalTo(checkBtn.snp.leading).offset(-10.i)
      $0.bottom.equalToSuperview().offset(-17.i)
    }
    
    checkBtn.snp.makeConstraints {
      //$0.top.bottom.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-25.i)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(18.i)
    }
    
//    checkBtn.imageView?.snp.remakeConstraints {
//      $0.width.height.equalTo(18.i)
//      $0.centerY.equalToSuperview()
//      $0.trailing.equalToSuperview().offset(-25.i)
//      $0.leading.equalTo(titleLabel.snp.trailing)
//      $0.width.lessThanOrEqualTo(18.i)
//    }
  }
  
}
