//
//  BasicWaitingCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class BasicWaitingCell: UITableViewCell {

    static let identifier = "BasicWaitingCell"
    
    let containerView: UIView = {
      let view = UIView()
      view.backgroundColor = .appColor(.whiteTwo)
      view.layer.cornerRadius = 14.i
      view.layer.shadowOpacity = 1
      view.layer.shadowColor = UIColor.appColor(.lgr4).cgColor
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
    
    let newView: UIView = {
      let view = UIView()
      view.clipsToBounds = true
      view.layer.cornerRadius = 3.i
      view.layer.borderColor = UIColor.appColor(.aLpk).cgColor
      view.layer.borderWidth = CGFloat(0.5).iOS
      return view
    }()
    
    let newLabel: UILabel = {
      let label = UILabel()
      label.text = "NEW"
      label.font = UIFont(name: "NanumSquareEB", size: 11.i)
      label.textColor = .appColor(.aPk)
      return label
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
      label.text = "3:49PM"
      label.font = UIFont(name: "NanumSquareB", size: 11.i)
      label.textColor = .appColor(.gr1)
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
      [hosNameLabel, newView, explainLabel, timeLabel]
        .forEach { containerView.addSubview($0) }
      [newLabel]
        .forEach { newView.addSubview($0) }
    }
    
    private func setupSNP() {
      containerView.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview().inset(10.i)
        $0.bottom.equalToSuperview()
      }
      
      hosNameLabel.snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(25.i)
      }
      
      newView.snp.makeConstraints {
        $0.top.trailing.equalToSuperview().inset(20.i)
        $0.height.equalTo(20.i)
      }
      
      newLabel.snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(4.i)
        $0.leading.trailing.equalToSuperview().inset(6.i)
      }
      
      explainLabel.snp.makeConstraints {
        $0.top.equalTo(newView.snp.bottom).offset(20.i)
        $0.leading.trailing.equalToSuperview().inset(25.i)
      }
      
      timeLabel.snp.makeConstraints {
        $0.top.equalTo(explainLabel.snp.bottom).offset(10.i)
        $0.leading.equalToSuperview().offset(25.i)
        $0.bottom.equalToSuperview().offset(-20.i)
      }
      
    }

}
