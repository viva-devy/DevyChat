//
//  ConversationsCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
  
class ConversationCell: UITableViewCell {
  
  static let identifier = "ConversationCell"
  
  let userImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.layer.cornerRadius = 35.i
    iv.layer.masksToBounds = true
    return iv
  }()
  
  let userNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumSquareB", size: 21.i)
    label.textColor = .appColor(.aBk)
    return label
  }()
  
  let userMessageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.textColor = .appColor(.aBk)
    label.numberOfLines = 0
    label.lineBreakMode = .byCharWrapping
    
    let attriString = NSMutableAttributedString(string: label.text ?? "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6.i
    attriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attriString.length))
    label.attributedText = attriString
    return label
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
  }
  
  // configure
  public func configure(with model: Conversation) {
    self.userMessageLabel.text = model.latestMessage.text
    self.userNameLabel.text = model.name
    print("model.latestMessage.text: " , model.latestMessage.text)
    
    let path = "images/\(model.otherUserEmail)_profile_picture.png"
    StorageManager.shared
      .downloadURL(for: path, completion: { [weak self] result in
      switch result {
      case .success(let url):
        DispatchQueue.main.async {
          self?.userImageView.sd_setImage(with: url, completed: nil)
        }
      case .failure(let error):
        print("failed to get image url: ", error)
      }
    })
  }
  
  private func addSubViews() {
    [userImageView, userNameLabel, userMessageLabel]
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    userImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(10.i)
      $0.width.height.equalTo(75.i)
    }
    
    userNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30.i)
      $0.leading.equalTo(userImageView.snp.trailing).offset(20.i)
      $0.trailing.equalToSuperview().inset(10.i)
 
    }
    
    userMessageLabel.snp.makeConstraints {
      $0.top.equalTo(userNameLabel.snp.bottom).offset(10.i)
      $0.leading.trailing.equalTo(userNameLabel)
      $0.bottom.equalToSuperview().offset(-30.i)
    }
    
  }
  
}
