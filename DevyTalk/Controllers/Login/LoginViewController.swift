//
//  LoginViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD


class LoginViewController: UIViewController {
  
  let loginView = LoginView()
  
  let spinner = JGProgressHUD(style: .dark)
  
  private var loginObserver:  NSObjectProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    // notification
    loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main) { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.navigationController?.dismiss(animated: true, completion: nil)
      
    }
    
    GIDSignIn.sharedInstance()?.presentingViewController = self
    
    setupNavi()
    addSubViews()
    setupSNP()
    
    loginView.loginBtn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    loginView.emailField.delegate = self
    loginView.passwordField.delegate = self
    loginView.fbLoginBtn.delegate = self
    
  }
  
  deinit {
    if let observer = loginObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  @objc private func loginButtonTapped() {
    loginView.emailField.resignFirstResponder()
    loginView.passwordField.resignFirstResponder()
    
    guard let email = loginView.emailField.text, let password = loginView.passwordField.text,  !email.isEmpty, !password.isEmpty, password.count >= 6 else {
      alertUserLoginError()
      return
    }
    
    spinner.show(in: view)
    
    // MARK: Firebase Log in
    
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
      guard let strongSelf = self else {
        return
      }
      
      DispatchQueue.main.async {
        strongSelf.spinner.dismiss()
      }
      
      guard let result = authResult, error == nil else {
        print("Failed to log in user with email: \(email)")
        return
      }
      
      let user = result.user
      
      let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
      DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
        switch result {
        case .success(let data):
          guard let userData = data as? [String: Any],
            let firstName = userData["first_name"] as? String,
            let lastName = userData["last_name"] as? String else {
              return
          }
           UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
          
        case .failure(let error):
          print("Failed to read data with error \(error)")
        }
      })
      
      UserDefaults.standard.set(email, forKey: "email")
      
      print("Logged In User: \(user)")
      strongSelf.navigationController?.dismiss(animated: true, completion: nil)
      
      
    }
    
  }
  
  func alertUserLoginError() {
    let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
    
  }
  
  private func setupNavi() {
    title = "Log In"
    
    navigationController?.navigationBar.prefersLargeTitles = false
    
    let rightBtn = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
    rightBtn.tintColor = .appColor(.gr1)
    
    navigationItem.rightBarButtonItem = rightBtn
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 35.i) ?? UIFont()]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
    
  }
  
  @objc private func didTapRegister() {
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func addSubViews() {
    [loginView]
      .forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    loginView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == loginView.emailField {
      loginView.passwordField.becomeFirstResponder()
    } else if textField == loginView.passwordField {
      loginButtonTapped()
    }
    
    return true
  }
  
}

extension LoginViewController: LoginButtonDelegate {
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    guard let token = result?.token?.tokenString else {
      print("User failed to log in with facebook ")
      return
    }
    
    let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
    
    
    facebookRequest.start { (_, result, error) in
      guard let result = result as? [String: Any], error == nil else {
        print("Failed to make facebook graph request")
        return
      }
      
      print("\(result)")
      
      guard let firstName = result["first_name"] as? String,
        let lastName = result["last_name"] as? String,
        let email = result["email"] as? String,
        let picture = result["picture"] as? [String: Any],
        let data = picture["data"] as? [String: Any],
        let pictureUrl = data["url"] as? String else {
          print("Failed to get email and name from fb result")
          return
      }
      
      UserDefaults.standard.set(email, forKey: "email")
      UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
      
      DatabaseManager.shared.userExists(with: email) { exists in
        if !exists {
//          let chatUser = UserData(cellDate: "0", chats: ["chat": "chat"], country: "KR", docBirth: "19901218", docEamil: email, docGender: 2, docId: UUID().uuidString, docName: "\(firstName) \(lastName)", docPhone: "01012345678", docPic: "0", docPosition: "환자", hosId: "0", hosName: "0", remoteState: -1, reserDate: "0", tfDoc: 99)
//          DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
//            if success {
//
//              guard let url = URL(string: pictureUrl) else {
//                return
//              }
//
//              print("Downloading data from facebook image")
//
//              URLSession.shared.dataTask(with: url, completionHandler: { data, _,_ in
//                guard let data = data else {
//                  print("Failed to get data from facebook")
//                  return
//                }
//
//                print("got data from FB, uploading...")
//
//                // upload iamge
//                let filename = chatUser.docPic
//                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//                  switch result {
//                  case .success(let downloadUrl):
//                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                    print(downloadUrl)
//                  case .failure(let error):
//                    print("Storage maanger error: \(error)")
//                  }
//                })
//              }).resume()
//            }
//          })
          
        }
        
      }
      
      
      // credential
      let credential = FacebookAuthProvider.credential(withAccessToken: token)
      FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
        guard let strongSelf = self else {
          return
        }
        
        guard authResult != nil, error == nil else {
          if let error = error {
            print("Facebook credential login failed, MFA may be needed - \(error)")
          }
          
          return
        }
        
        print("Successfully logged user in")
        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
      }
      
    }
    
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    // no operation
  }
  
  
}
