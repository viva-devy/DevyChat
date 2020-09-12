//
//  CustomInputBar.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/04.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class CustomInputBar: InputBarAccessoryView {
  
  let addBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "add"), for: .normal)
    btn.setImage(UIImage(named: "add"), for: .highlighted)
    btn.contentMode = .scaleAspectFit
    return btn
  }()
  
  let messageView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8.i
    view.layer.borderWidth = CGFloat(0.35).iOS
    view.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return view
  }()
  
  let messageField: UITextField = {
    let tf = UITextField()
    tf.font = UIFont(name: "NanumSquareR", size: 14.i)
    tf.textColor = UIColor.appColor(.aBk)
    tf.placeholder = "Message.."
    tf.backgroundColor = .white
    return tf
  }()
  
  
  let sendBtn: InputBarSendButton = {
    let btn = InputBarSendButton()
    btn.setImage(UIImage(named: "send"), for: .normal)
    btn.setImage(UIImage(named: "send"), for: .highlighted)
    btn.contentMode = .scaleAspectFit
    return btn
  }()
  
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.clipsToBounds = true
    return view
  }()
  
  let albumIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "album")
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  let albumLabel: UILabel = {
    let label = UILabel()
    label.text = "Album"
    label.font = UIFont(name: "NanumSquareB", size: 13.i)
    label.textColor = .appColor(.dark)
    return label
  }()
  
  let cameraIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "camera")
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  let cameraLabel: UILabel = {
    let label = UILabel()
    label.text = "Camera"
    label.font = UIFont(name: "NanumSquareB", size: 13.i)
    label.textColor = .appColor(.dark)
    return label
  }()
  
  let fileIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "file")
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  let fileLabel: UILabel = {
    let label = UILabel()
    label.text = "File"
    label.font = UIFont(name: "NanumSquareB", size: 13.i)
    label.textColor = .appColor(.dark)
    return label
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    sendBtn.addTarget(self, action: #selector(didTapSendBtn(_:)), for: .touchUpInside)
  }
  
  @objc func didTapSendBtn(_ sender: UIButton) {
    
    sender.isSelected ? showInputBox(show: true) : showInputBox(show: false)
  }
  
  
  private func showInputBox(show: Bool) {
    show ? showInputBox() : hideInputBox()
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
  
  private func showInputBox() {
    [addBtn, messageView, sendButton]
      .forEach { self.addSubview($0) }
    messageView.addSubview(messageField)
    [containerView]
      .forEach { self.addSubview($0) }
    [albumIV, albumLabel, cameraIV, cameraLabel, fileIV, fileLabel]
    .forEach { containerView.addSubview($0) }
 
    addBtn.snp.remakeConstraints {
      $0.top.equalToSuperview().offset(20.i)
      $0.leading.equalToSuperview().offset(11.i)
      $0.width.height.equalTo(24.i)
    }
    
    messageView.snp.remakeConstraints {
      $0.top.equalToSuperview().inset(10.i)
      $0.height.equalTo(45.i)
      $0.leading.equalTo(addBtn.snp.trailing).offset(10.i)
      $0.trailing.equalToSuperview().offset(-10.i)
    }
    
    messageField.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10.i)
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    sendBtn.snp.remakeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-8.i)
      $0.width.height.equalTo(30.i)
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(messageView.snp.bottom).offset(10.i)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    cameraIV.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12.i)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(45.i)
    }
    
    cameraLabel.snp.makeConstraints {
      $0.centerX.equalTo(cameraIV.snp.centerX)
      $0.bottom.equalToSuperview().offset(-20.i)
    }
    
    albumIV.snp.makeConstraints {
      $0.top.width.height.equalTo(cameraIV)
      $0.leading.equalToSuperview().offset(50.i)
    }
    
    albumLabel.snp.makeConstraints {
      $0.centerX.equalTo(albumIV.snp.centerX)
      $0.bottom.equalToSuperview().offset(-20.i)
    }
    
    fileIV.snp.makeConstraints {
      $0.top.width.height.equalTo(cameraIV)
      $0.trailing.equalToSuperview().offset(-50.i)
    }
    
    fileLabel.snp.makeConstraints {
      $0.centerX.equalTo(fileIV.snp.centerX)
      $0.bottom.equalToSuperview().offset(-20.i)
    }
    
    
  }
  
  private func hideInputBox() {
    containerView.removeFromSuperview()
    
    addBtn.snp.remakeConstraints {
      $0.top.equalToSuperview().offset(20.i)
      $0.leading.equalToSuperview().offset(11.i)
      $0.width.height.equalTo(24.i)
    }
    
    messageView.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview().inset(10.i)
      $0.height.equalTo(45.i)
      $0.leading.equalTo(addBtn.snp.trailing).offset(10.i)
      $0.trailing.equalToSuperview().offset(-10.i)
    }
    
    messageField.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10.i)
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    sendBtn.snp.remakeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-8.i)
      $0.width.height.equalTo(30.i)
    }
  }
  
  private func addSubViews() {
    [addBtn, messageView, sendButton]
      .forEach { self.addSubview($0) }
    messageView.addSubview(messageField)
    
  }
  
  private func setupSNP() {
    addBtn.snp.remakeConstraints {
      $0.top.equalToSuperview().offset(20.i)
      $0.leading.equalToSuperview().offset(11.i)
      $0.width.height.equalTo(24.i)
    }
    
    messageView.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview().inset(10.i)
      $0.height.equalTo(45.i)
      $0.leading.equalTo(addBtn.snp.trailing).offset(10.i)
      $0.trailing.equalToSuperview().offset(-10.i)
    }
    
    messageField.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10.i)
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    sendBtn.snp.remakeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-8.i)
      $0.width.height.equalTo(30.i)
    }
    
  }


}
