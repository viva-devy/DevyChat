//
//  GlobalWaitingCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class GlobalWaitingCell: UITableViewCell {
  
  static let identifier = "GlobalWaitingCell"
  
  var chat: ChatList? {
    willSet(new) {
      guard let chat = new else { return }
      self.hosNameLabel.text = chat.title
      self.newIV.alpha = chat.cTotalUnreadCount == 0 ? 0 : 1
      
      guard let en = chat.lastMessage?.message, let chatID = chat.chatID else {
        self.message = "-"
        return }
      API.shared.getAESKey(with: chatID) {
        guard let aes = $0, let clear = Secu.rity.decryptionMsg(en, AESKey: aes) else {
          self.message = "-"
          return }
        self.message = clear
      }
    }
  }
  
  var message: String = "" {
    willSet(new) {
      let attriString = NSMutableAttributedString(string: new)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 10.i
      attriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attriString.length))
      explainLabel.attributedText = attriString
    }
  }
  
  let containerView: UIView = {
    let view = UIView()
    view.clipsToBounds = false
    view.backgroundColor = .appColor(.whiteTwo)
    view.layer.cornerRadius = 14.i
    view.layer.shadowOpacity = 1
    view.layer.shadowColor = UIColor.appColor(.lgr3).cgColor
    view.layer.shadowRadius = 3
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    return view
  }()
  
  let hosNameLabel: UILabel = {
    let label = UILabel()
    label.text = "SUN HOSPITAL"
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.textColor = .appColor(.aBk)
    return label
  }()
  
  let newIV: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .clear
    iv.contentMode = .center
    iv.image = UIImage(named: "newPk")
    return iv
  }()
  
  let explainLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome to our waiting room!\nHow can we help you?"
    label.font = UIFont(name: "NanumSquareR", size: 17.i)
    label.textColor = .appColor(.aBk)
    
    label.numberOfLines = 2
    label.lineBreakMode = .byCharWrapping
    let attriString = NSMutableAttributedString(string: label.text ?? "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10.i
    attriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attriString.length))
    
    let explain = ((label.text ?? "") as NSString).range(of: "waiting room!")
    attriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "NanumSquareEB", size: 17.i) ?? UIFont(), range: explain)
    label.attributedText = attriString
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "May 24th"
    label.font = UIFont(name: "NanumSquareB", size: 10.i)
    label.textColor = .appColor(.gr1)
    return label
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.appColor(.lgr2)
    return view
  }()
  
  // 간호사 뷰
  let greenView: UIView = {
    let view = UIView()
    view.backgroundColor = .appColor(.amt)
    view.clipsToBounds = true
    view.layer.cornerRadius = 4.i
    return view
  }()
  
  let nurseLabel: UILabel = {
    let label = UILabel()
    label.text = "홍길동 간호사"
    label.font = UIFont(name: "NanumSquareB", size: 11.i)
    label.textColor = .appColor(.gr2)
    return label
  }()
  
  // 의사 뷰  - 의사가 들어왔을때 나옴ㄴ
  let aVbView: UIView = {
    let view = UIView()
    view.backgroundColor = .appColor(.aVb)
    view.clipsToBounds = true
    return view
  }()
  
  let doctorLabel: UILabel = {
    let label = UILabel()
    label.text = "Dr. Kim"
    label.font = UIFont(name: "NanumSquareB", size: 11.i)
    label.textColor = .appColor(.aPk)
    return label
  }()
  
  // 종료된 시간일때 나옴
  let endTimeView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.cornerRadius = 3.i
    view.layer.borderColor = UIColor.appColor(.aVb).cgColor
    view.layer.borderWidth = CGFloat(0.5).iOS
    return view
  }()
  
  let endTimeLabel: UILabel = {
    let label = UILabel()
    label.text = "8/1, 15:30"
    label.textAlignment = .right
    label.font = UIFont(name: "NanumSquareEB", size: 11.i)
    label.textColor = .appColor(.aVb)
    return label
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
    
    
  }
  
  private func addSubViews() {
    [containerView]
      .forEach { self.contentView.addSubview($0) }
    
    [hosNameLabel, newIV, explainLabel, timeLabel, lineView, greenView, nurseLabel, aVbView, doctorLabel, endTimeView]
      .forEach { containerView.addSubview($0) }
    [endTimeLabel]
      .forEach { endTimeView.addSubview($0) }
  }
  
  private func setupSNP() {
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(10.i)
      $0.bottom.equalToSuperview()
    }
    
    hosNameLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(25.i)
    }
    
    endTimeView.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(18.i)
      $0.height.equalTo(20.i)
    }
    
    endTimeLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(4.i)
      $0.leading.trailing.equalToSuperview().inset(5.i)
    }
    
    newIV.snp.makeConstraints {
      $0.top.equalToSuperview().offset(75.i)
      $0.trailing.equalToSuperview().offset(-20.i)
      $0.height.width.equalTo(24.i)
    }
    
    explainLabel.snp.makeConstraints {
      $0.top.equalTo(hosNameLabel.snp.bottom).offset(18.i)
      $0.leading.trailing.equalToSuperview().inset(25.i)
    }
    
    timeLabel.snp.makeConstraints {
      $0.top.equalTo(explainLabel.snp.bottom).offset(10.i)
      $0.leading.equalToSuperview().offset(25.i)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(timeLabel.snp.bottom).offset(15.i)
      $0.leading.equalToSuperview().offset(25.i)
      $0.trailing.equalToSuperview().offset(-40.i)
      $0.height.equalTo(CGFloat(0.5).iOS)
    }
    
    greenView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(19.i)
      $0.leading.equalToSuperview().offset(25.i)
      $0.width.equalTo(7.i)
      $0.height.equalTo(8.i)
    }
    
    nurseLabel.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(17.i)
      $0.leading.equalTo(greenView.snp.trailing).offset(4.i)
      $0.bottom.equalToSuperview().offset(-18.i)
    }
    
  }
  

  
}
