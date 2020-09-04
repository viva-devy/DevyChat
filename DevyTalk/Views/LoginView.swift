//
//  LoginView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit
import GoogleSignIn

class LoginView: UIView {
  
  private let imageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "logo")
    iv.tintColor = .appColor(.darkSkyBlue)
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
   let emailField: UITextField = {
    let tf = UITextField()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .continue
    tf.layer.cornerRadius = 12.i
    tf.layer.borderWidth = 1.i
    tf.layer.borderColor = UIColor.appColor(.gr1).cgColor
    tf.placeholder = "Email Address.."
    tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5.i, height: 0))
    tf.leftViewMode = .always
    tf.backgroundColor = .white
    return tf
  }()
  
   let passwordField: UITextField = {
    let tf = UITextField()
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .done
    tf.layer.cornerRadius = 12.i
    tf.layer.borderWidth = 1.i
    tf.layer.borderColor = UIColor.appColor(.gr1).cgColor
    tf.placeholder = "Password.."
    tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5.i, height: 0))
    tf.leftViewMode = .always
    tf.backgroundColor = .white
    tf.isSecureTextEntry = true
    return tf
  }()
  
  let loginBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Log In", for: .normal)
    btn.backgroundColor = .appColor(.aBl2)
    btn.setTitleColor(.appColor(.whiteTwo), for: .normal)
    btn.layer.cornerRadius = 12.i
    btn.layer.masksToBounds = true
    btn.titleLabel?.font = UIFont(name: "NanumSquareB", size: 20.i)
    return btn
  }()
  
  let fbView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.cornerRadius = 12.i
    view.backgroundColor = .appColor(.whiteTwo)
    view.layer.borderColor = UIColor.appColor(.dgr1).cgColor
    view.layer.borderWidth = CGFloat(0.5).iOS
    return view
  }()
  
  let fbLoginBtn: FBLoginButton = {
    let btn = FBLoginButton()
    btn.permissions = ["email, public_profile"]
    btn.backgroundColor = .white
    return btn
  }()
  
  let googleView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.cornerRadius = 12.i
    view.backgroundColor = .appColor(.whiteTwo)
    return view
  }()
  
  let googleLoginBtn: GIDSignInButton = {
    let btn = GIDSignInButton()
    btn.backgroundColor = .white
    return btn
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .appColor(.whiteTwo)
    addSubViews()
    setupSNP()
  }
  
  // Firebase Login
  
  private func addSubViews() {
    [scrollView]
      .forEach { self.addSubview($0) }
    [imageView, emailField, passwordField, loginBtn, fbView, googleView]
      .forEach { scrollView.addSubview($0) }
    [fbLoginBtn]
      .forEach { fbView.addSubview($0) }
    [googleLoginBtn]
      .forEach { googleView.addSubview($0) }
  }
  
  private func setupSNP() {
    scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.width.height.equalToSuperview()
    }
    
    imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(50.i)
      $0.width.height.equalTo(70.i)
    }
    
    emailField.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(30.i)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(30.i)
      $0.height.equalTo(50.i)
    }
    
    passwordField.snp.makeConstraints {
      $0.top.equalTo(emailField.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(emailField)
    }
    
    loginBtn.snp.makeConstraints {
      $0.top.equalTo(passwordField.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(emailField)
    }

    fbView.snp.makeConstraints {
      $0.top.equalTo(loginBtn.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(emailField)
    }
    
    fbLoginBtn.snp.makeConstraints {
      $0.leading.trailing.equalTo(emailField)
    }
    
    googleView.snp.makeConstraints {
      $0.top.equalTo(fbView.snp.bottom).offset(15.i)
      $0.centerX.leading.trailing.height.equalTo(emailField)
    }
    
    googleLoginBtn.snp.makeConstraints {
      $0.leading.trailing.equalTo(emailField)
    }
    
    
  }
  
}
