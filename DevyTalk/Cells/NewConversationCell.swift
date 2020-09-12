//
//  NewConversationCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/28.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SDWebImage

class NewConversationCell: UITableViewCell {
  
  static let identifier = "NewConversationCell"
  
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

  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
  }
  
  // configure
  public func configure(with model: SearchResult) {
    self.userNameLabel.text = model.name
    
    let path = "images/\(model.email)_profile_picture.png"
    StorageManager.shared
      .downloadURL(for: path, completion: { [weak self] result in
        switch result {
        case .success(let url):
          DispatchQueue.main.async {
            self?.userImageView.sd_setImage(with: url, completed: nil)
          }
        case .failure(_):
          ()
        }
      })
  }
  
  private func addSubViews() {
    [userImageView, userNameLabel]
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
      $0.bottom.equalToSuperview().offset(-30.i)
    }
 
    
  }
  
}
