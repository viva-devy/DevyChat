//
//  RegisterViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
  
  let registerView = RegisterView()
  
  let spinner = JGProgressHUD(style: .dark)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavi()
    addSubViews()
    setupSNP()
    
    registerView.registerBtn.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    registerView.emailField.delegate = self
    registerView.passwordField.delegate = self
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeRecognizer))
    registerView.imageView.addGestureRecognizer(gesture)
    
  }
  
  @objc private func registerButtonTapped() {
    registerView.firstNameField.resignFirstResponder()
    registerView.passwordField.resignFirstResponder()
    
    guard let firstName = registerView.firstNameField.text, let lastName = registerView.lastNameField.text, let email = registerView.emailField.text, let password = registerView.passwordField.text, !firstName.isEmpty, !lastName.isEmpty,  !email.isEmpty, !password.isEmpty, password.count >= 6 else {
      alertUserLoginError()
      return
    }
    
    spinner.show(in: view)
    
    // MARK: Firebase Log in
    
    DatabaseManager.shared.userExists(with: email) { [weak self] (exists) in
      guard let strongSelf = self else {
        return
      }
      
      DispatchQueue.main.async {
          strongSelf.spinner.dismiss()
        }
      
      guard !exists else {
        // user already exists
        strongSelf.alertUserLoginError(message: "Looks like a user account for that email addreess already exists.")
        return
      }
      
      FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
        
        guard authResult != nil, error == nil else {
          print("Error cureating user")
          return
        }
        
        // uid값이 다르니까 users안에 새로 추가된다
//        let chatUser = UserData(cellDate: "0", chats: nil, country: "KR", docBirth: "19901218", docEamil: email, docGender: 2, docId: UUID().uuidString, docName: "\(firstName) \(lastName)", docPhone: "01012345678", docPic: "0", docPosition: "환자", hosId: "0", hosName: "0", remoteState: -1, reserDate: "0", tfDoc: 99)
        
//        DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
//          if success {
//            // upload image
//            guard let image = strongSelf.registerView.imageView.image,
//              let data = image.pngData() else {
//                return
//            }
//            let filename = chatUser.docPic
//            StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//              switch result {
//              case .success(let downloadUrl):
//                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                print(downloadUrl)
//              case .failure(let error):
//                print("Storage maanger error: \(error)")
//              }
//            })
//          }
//        })
        
        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        
      }
    } // 얘임
    
  }
  
  @objc private func didTapChangeRecognizer() {
    presentPhotoActionSheet()
  }
  
  func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
    
  }
  
  func setupNavi() {
    title = "Register"
    
    navigationController?.navigationBar.prefersLargeTitles = false
    
    let rightBtn = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
    rightBtn.tintColor = .appColor(.gr1)
    
    navigationItem.rightBarButtonItem = rightBtn
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 35.i) ?? UIFont()]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
    
  }
  
  
  private func addSubViews() {
    [registerView]
      .forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    registerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  
  @objc private func didTapRegister() {
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension RegisterViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == registerView.emailField {
      registerView.passwordField.becomeFirstResponder()
    } else if textField == registerView.passwordField {
      registerButtonTapped()
    }
    
    return true
  }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func presentPhotoActionSheet() {
    let actionSheet = UIAlertController(title: "Profile Picture",
                                        message: "How would you like to select a picture?",
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
                                          self?.presentCamera()
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
                                          self?.presentPhotoPicker()
    }))
    
    present(actionSheet, animated: true, completion: nil)
  }
  
  func presentCamera() {
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true, completion: nil)
  }
  
  func presentPhotoPicker() {
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    print(info)
    
    guard let selecteImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
      
      return }
    self.registerView.imageView.image = selecteImage
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
