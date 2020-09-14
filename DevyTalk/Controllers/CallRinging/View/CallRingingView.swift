//
//  CallRingingView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class CallRingingView: UIView {
  
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  let cameraIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "cameraOn")
    iv.backgroundColor = .clear
    iv.contentMode = .scaleAspectFill
    iv.isUserInteractionEnabled = true
    return iv
  }()
  
  let recipientLabel: UILabel = {
    let label = UILabel()
    label.text = "Dr.Johan Kim"
    label.font = UIFont(name: "NanumSquareEB", size: 23.i)
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  let callingLabel: UILabel = {
    let label = UILabel()
    label.text = "Calling…"
    label.textAlignment = .center
    label.font = UIFont(name: "NanumSquareB", size: 17.i)
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  let mainIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "callTitleIV")
    iv.backgroundColor = .clear
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  let declineIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "exitMobile")
    iv.backgroundColor = .clear
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  let declineLabel: UILabel = {
    let label = UILabel()
    label.text = "Decline"
    label.textAlignment = .center
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  let acceptIV: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.image = UIImage(named: "play")
    iv.backgroundColor = .clear
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  let acceptLabel: UILabel = {
    let label = UILabel()
    label.text = "Accept"
    label.textAlignment = .center
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
    setGradientBackground(colorTop: .appColor(.deepDusk), colorBottom: .appColor(.deepLilac), view: self)
  }
  
  private func addSubViews() {
    [containerView]
      .forEach { self.addSubview($0) }
    [cameraIV, recipientLabel, callingLabel, mainIV, declineIV, declineLabel, acceptIV, acceptLabel]
      .forEach { containerView.addSubview($0) }
    
  }
  
  private func setupSNP() {
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
    }
    
    cameraIV.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15.i)
      $0.width.height.equalTo(40.i)
      $0.trailing.equalToSuperview().offset(-15.i)
    }
    
    recipientLabel.snp.makeConstraints {
      $0.top.equalTo(cameraIV.snp.bottom).offset(72.i)
      $0.centerX.equalToSuperview()
    }
    
    callingLabel.snp.makeConstraints {
      $0.top.equalTo(recipientLabel.snp.bottom).offset(20.i)
      $0.centerX.equalToSuperview()
    }
    
    mainIV.snp.makeConstraints {
      $0.top.equalTo(callingLabel.snp.bottom).offset(40.i)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(125.i)
      $0.height.equalTo(176.i)
    }
    
    declineIV.snp.makeConstraints {
      $0.top.equalTo(mainIV.snp.bottom).offset(90.i)
      $0.leading.equalToSuperview().offset(66.i)
      $0.width.height.equalTo(58.i)
    }
    
    declineLabel.snp.makeConstraints {
      $0.top.equalTo(declineIV.snp.bottom).offset(15.i)
      $0.centerX.equalTo(declineIV.snp.centerX)
    }
    
    acceptIV.snp.makeConstraints {
      $0.top.width.height.equalTo(declineIV)
      $0.trailing.equalToSuperview().offset(-66.i)
    }
    
    acceptLabel.snp.makeConstraints {
      $0.top.equalTo(acceptIV.snp.bottom).offset(15.i)
      $0.centerX.equalTo(acceptIV.snp.centerX)
    }
    
    
  }
  
  func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, view: UIView) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor,]
    gradientLayer.locations = [0, 1]
    gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  
}
