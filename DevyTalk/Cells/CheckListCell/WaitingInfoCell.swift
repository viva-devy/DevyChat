//
//  WaitingInfoCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class WaitingInfoCell: UITableViewCell {

    static let identifier = "WaitingInfoCell"
    
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
    
    let bookNowIV: UIImageView = {
      let iv = UIImageView()
      iv.clipsToBounds = true
      iv.backgroundColor = .appColor(.gr1)
      iv.layer.cornerRadius = 27.i
      iv.contentMode = .scaleAspectFit
      return iv
    }()
    
    
    
    override func didMoveToSuperview() {
      super.didMoveToSuperview()
      
      self.backgroundColor = .clear
      addSubViews()
      setupSNP()
      
    }
    
    private func addSubViews() {
      [explainLabel, bookNowIV]
        .forEach { self.contentView.addSubview($0) }
      
    }
    
    private func setupSNP() {
      explainLabel.snp.makeConstraints {
        $0.top.equalToSuperview().offset(35.i)
        $0.leading.equalToSuperview().offset(25.i)
        $0.trailing.equalTo(bookNowIV.snp.leading).offset(-30.i)
      }
      
      bookNowIV.snp.makeConstraints {
        $0.top.equalTo(explainLabel)
        $0.trailing.equalToSuperview().offset(-25.i)
        $0.width.height.equalTo(54.i)
        $0.bottom.equalToSuperview()
      }
      
      
    }
    

}
