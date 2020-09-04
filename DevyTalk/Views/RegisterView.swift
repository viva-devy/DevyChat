//
//  RegisterView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class RegisterView: UIView {
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    if #available(iOS 13.0, *) {
      iv.image = UIImage(systemName: "person.circle")
    } else {
      iv.image = UIImage(named: "user")
      // Fallback on earlier versions
    }
    iv.contentMode = .scaleAspectFit
    iv.tintColor = UIColor.appColor(.gr2)
    iv.isUserInteractionEnabled = true
    iv.layer.masksToBounds = true
    iv.layer.borderWidth = 1.i
    iv.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return iv
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isUserInteractionEnabled = true
    return scrollView
  }()
  
  let firstView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12.i
    view.layer.borderWidth = 1.i
    view.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return view
  }()
  
  let firstNameField: UITextField = {
    let tf = UITextField()
    tf.becomeFirstResponder()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .continue
    tf.placeholder = "FirstName.."
    tf.backgroundColor = .white
    return tf
  }()
  
  let lastView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12.i
    view.layer.borderWidth = 1.i
    view.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return view
  }()
  
  let lastNameField: UITextField = {
    let tf = UITextField()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .continue
    tf.placeholder = "LastName.."
    tf.backgroundColor = .white
    return tf
  }()
  
  let emailView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12.i
    view.layer.borderWidth = 1.i
    view.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return view
  }()
  
  let emailField: UITextField = {
    let tf = UITextField()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .continue
    tf.placeholder = "Email Address.."
    tf.backgroundColor = .white
    return tf
  }()
  
  let passwordView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12.i
    view.layer.borderWidth = 1.i
    view.layer.borderColor = UIColor.appColor(.gr1).cgColor
    return view
  }()
  
  let passwordField: UITextField = {
    let tf = UITextField()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .done
    tf.placeholder = "Password.."
    tf.backgroundColor = .white
    tf.isSecureTextEntry = true
    return tf
  }()
  
  
  let registerBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Register", for: .normal)
    btn.backgroundColor = .appColor(.aBl2)
    btn.setTitleColor(.appColor(.whiteTwo), for: .normal)
    btn.layer.cornerRadius = 12.i
    btn.layer.masksToBounds = true
    btn.titleLabel?.font = UIFont(name: "NanumSquareB", size: 20.i)
    return btn
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
    
    imageView.layer.cornerRadius = 40.i
  }
  
  
  
  
  
  
  // Firebase Login
  
  private func addSubViews() {
    [scrollView]
      .forEach { self.addSubview($0) }
    [imageView, firstView, lastView, emailView, passwordView, registerBtn]
      .forEach { scrollView.addSubview($0) }
    [firstNameField]
      .forEach { firstView.addSubview($0) }
    [lastNameField]
      .forEach { lastView.addSubview($0) }
    [emailField]
      .forEach { emailView.addSubview($0) }
    [passwordField]
      .forEach { passwordView.addSubview($0) }
    
  }
  
  private func setupSNP() {
    scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.width.height.equalToSuperview()
    }
    
    imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(50.i)
      $0.width.height.equalTo(80.i)
    }
    
    firstView.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(30.i)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(30.i)
      $0.height.equalTo(50.i)
    }
    
    firstNameField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    lastView.snp.makeConstraints {
      $0.top.equalTo(firstView.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(firstView)
    }
    
    lastNameField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    emailView.snp.makeConstraints {
      $0.top.equalTo(lastView.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(firstView)
    }
    
    emailField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    passwordView.snp.makeConstraints {
      $0.top.equalTo(emailView.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(firstView)
    }
    
    passwordField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(15.i)
    }
    
    registerBtn.snp.makeConstraints {
      $0.top.equalTo(passwordView.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(firstView)
    }
    
    
  }
  
}
