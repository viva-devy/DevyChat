//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController {
  
  let profileView = ProfileView()
  let data = ["Log Out"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavi()
    addSubViews()
    setupSNP()
    
    profileView.tableView.dataSource = self
    profileView.tableView.delegate = self
    profileView.tableView.tableHeaderView = self.createTableViewHeader()
    
    
  }
  
  func createTableViewHeader() -> UIView? {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
      return nil
    }
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    let fileName = safeEmail + "_profile_picture.png"
    
    let path = "images/"+fileName
    print("path: ", path)
    
    let headerView: UIView = {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300.i))
      view.backgroundColor = .appColor(.amt)
      return view
    }()
    
    let imageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFill
      iv.backgroundColor = .white
      iv.layer.borderColor = UIColor.white.cgColor
      iv.layer.borderWidth = 2.i
      iv.layer.masksToBounds = true
      iv.layer.cornerRadius = 75.i
      return iv
    }()
    
    headerView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(75.i)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(150.i)
    }

    StorageManager.shared.downloadURL(for: path) { [weak self] result in
      switch result {
      case .success(let url):
        self?.downloadImage(imageView: imageView, url: url)
        print(url)
      case .failure(let error):
        print("Failed to get download url: \(error)")
      }
    }
    
    return headerView
  }
  
  func downloadImage(imageView: UIImageView, url: URL) {
    URLSession.shared.dataTask(with: url) { data, _, err in
      guard let data = data, err == nil else {
        return
      }
      
      DispatchQueue.main.async {
        let image = UIImage(data: data)
        imageView.image = image
      }

    }.resume()
  }
  
  private func setupNavi() {
     title = "Profile"
     
     navigationController?.navigationBar.prefersLargeTitles = true
     let rightBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(didTapRegister))
     rightBtn.tintColor = .appColor(.gr1)
     
     navigationItem.rightBarButtonItem = rightBtn
     
     navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 35.i) ?? UIFont()]
     navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
     
     navigationController?.navigationBar.shadowImage = UIImage()
     navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
     
   }
   
   @objc private func didTapRegister() {

   }
   
   private func addSubViews() {
     [profileView]
       .forEach { view.addSubview($0) }
     
   }
   
   private func setupSNP() {
     profileView.snp.makeConstraints {
       $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
       $0.leading.trailing.bottom.equalToSuperview()
     }
   }
  
  
  
}


extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
    cell.titleLabel.text = data[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
  
  
}

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      // Log Out facebook
      FBSDKLoginKit.LoginManager().logOut()
      
      // google Log Out
      GIDSignIn.sharedInstance()?.signOut()
      
      do {
        try FirebaseAuth.Auth.auth().signOut()
        
        let vc = LoginViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        strongSelf.present(navi, animated: true, completion: nil)
        
      }
      catch {
        print("Failed to log out")
      }
      
      
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(actionSheet, animated: true, completion: nil)
    
  }
}
