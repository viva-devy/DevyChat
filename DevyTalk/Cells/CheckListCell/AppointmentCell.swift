//
//  AppointmentCell.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/02.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
  
  static let identifier = "AppointmentCell"
  
  let gradientView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.cornerRadius = 14.i
    view.layer.shadowOpacity = 1
    view.layer.shadowColor = UIColor.appColor(.aVb, alpha: 0.5).cgColor
    view.layer.shadowRadius = 3
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    return view
  }()
  
  let timeIV: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.image = UIImage(named: "theTime")
    iv.tintColor = .appColor(.whiteTwo)
    return iv
  }()
  
  let appointmentLabel: UILabel = {
    let label = UILabel()
    label.text = "Up to the appointment"
    label.font = UIFont(name: "NanumSquareB", size: 14.i)
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  let appointmentTimeLabel: UILabel = {
    let label = UILabel()
    label.text = "06:34:32"
    label.font = UIFont(name: "NanumSquareEB", size: 23.i)
    label.textColor = .appColor(.whiteTwo)
    label.textAlignment = .right
    return label
  }()
  
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
    setGradientBackground(colorTop: .appColor(.aVb, alpha: 0.9), colorBottom: .appColor(.aBl2, alpha: 0.7), view: self.gradientView)
  }
  
  private func addSubViews() {
    [gradientView]
      .forEach { self.contentView.addSubview($0) }
    [timeIV, appointmentLabel, appointmentTimeLabel]
      .forEach { gradientView.addSubview($0) }
  }
  
  private func setupSNP() {
    gradientView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(45.i)
      $0.leading.trailing.equalToSuperview().inset(10.i)
      $0.bottom.equalToSuperview()
    }
    
    timeIV.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(25.i)
      $0.leading.equalToSuperview().offset(20.i)
      $0.width.height.equalTo(15.i)
    }
    
    appointmentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(timeIV.snp.trailing).offset(7.i)
    }
    
    appointmentTimeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20.i)
    }
  }
  
  func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, view: UIView) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    gradientLayer.locations = [0, 1]
    gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10.i - 10.i, height: 65.i)
    //    gradientLayer.frame = gradientView.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
}
