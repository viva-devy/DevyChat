//
//  ConversationsViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
  
  let conversationsView = ConversationsView()
  
  let spinner = JGProgressHUD(style: .dark)
  
  private var conversations = [Conversation]()
  
  private var loginObserver:  NSObjectProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavi()
    addSubViews()
    setupSNP()
    
    conversationsView.tableView.dataSource = self
    conversationsView.tableView.delegate = self
    fetchConversations()
    startListeningForConversations()
    
    loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main) { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.startListeningForConversations()
      
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    validateAuth()
    
  }
  
  
  private func startListeningForConversations() {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
      return
    }
    
    if let observer = loginObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    
    print("starting conversation fetch..")
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
      switch result {
      case .success(let conversations):
        print("successfully got conversation models")
        guard !conversations.isEmpty else {
          return
        }
        self?.conversations = conversations
        
        DispatchQueue.main.async {
          self?.conversationsView.tableView.reloadData()
        }
        
      case .failure(let error):
        ()
//        print("failed to get convos: \(error)")
      }
    })
  }
  
  @objc private func didTapComposeButton() {
    let vc = NewConversationViewController()
    vc.completion = { [weak self] result in
      guard let strongSelf = self else {
        return
      }
      
      let currentConversations = strongSelf.conversations
      
      if let targetConversation = currentConversations.first(where: {
        $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
      }) {
        let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
        vc.isNewConversation = false
        vc.title = targetConversation.name
        vc.navigationItem.largeTitleDisplayMode = .never
        
        strongSelf.navigationController?.pushViewController(vc, animated: true)
      }
      else {
        strongSelf.createNewConversation(result: result)
      }
    }
    let navVC = UINavigationController(rootViewController: vc)
    navVC.modalPresentationStyle = .overFullScreen
    present(navVC, animated: true)
  }
  
  private func createNewConversation(result: SearchResult) {
    let name = result.name
    let email = DatabaseManager.safeEmail(emailAddress: result.email)
    

    // check in datbase if conversation with these two users exists
    // if it does, reuse conversation id
    // otherwise use existing code
    
    DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let conversationId):
        let vc = ChatViewController(with: email, id: conversationId)
        vc.isNewConversation = false
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        strongSelf.navigationController?.pushViewController(vc, animated: true)
      case .failure(_):
        let vc = ChatViewController(with: email, id: nil)
        vc.isNewConversation = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        strongSelf.navigationController?.pushViewController(vc, animated: true)
      }
    })
  }
  
  private func validateAuth() {
    if FirebaseAuth.Auth.auth().currentUser == nil {
      
      let vc = LoginViewController()
      let navi = UINavigationController(rootViewController: vc)
      navi.modalPresentationStyle = .fullScreen
      present(navi, animated: false, completion: nil)
      
    }
  }
  
  private func fetchConversations() {
    conversationsView.tableView.isHidden = false
  }
  
  private func addSubViews() {
    [conversationsView]
      .forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    conversationsView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupNavi() {
    title = "Chats"
    let leftBtn = UIBarButtonItem(title: "NewChat", style: .done, target: self, action: #selector(didTapLeftBtn))
    //    navigationController?.navigationBar.prefersLargeTitles = true
    let rightBtn = UIBarButtonItem(title: "✎", style: .done, target: self, action: #selector(didTapComposeButton))
    
    rightBtn.tintColor = .appColor(.aBk)
    navigationItem.leftBarButtonItem = leftBtn
    navigationItem.rightBarButtonItem = rightBtn
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 35.i) ?? UIFont()]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
    
  }
  
  @objc private func didTapLeftBtn() {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
      return
    }
    let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    DatabaseManager.shared.userExists(with: safeEmail) { [weak self] (exists) in
      guard let strongSelf = self else {
        return
      }
      
      DispatchQueue.main.async {
        strongSelf.spinner.dismiss()
      }
      
      guard !exists else {
        return
      }
      
      // UUID 는 생성 될 때마다 새로운값을 만듦 중복은 없음
//      let chatUser = UserData(cellDate: "0", chats: nil, country: "KR", docBirth: "19901218", docEamil: safeEmail, docGender: 2, docId: safeEmail, docName: "이름", docPhone: "01012345678", docPic: "0", docPosition: "환자", hosId: "0", hosName: "0", remoteState: -1, reserDate: "0", tfDoc: 99)
     let chatUser = UserData()
       DatabaseManager.shared.insertUser(with: chatUser, completion: { [weak self] success in
        if success {
          // 여기서 채팅방 리스트가 있는지 확인?
          let chatListVC = ChatListVC()
//          chatListVC.chatUser.append(chatUser)
          chatListVC.uid = chatUser.docID ?? "docId"
          chatListVC.hosData = ("H24783", "대전선병원")
          chatListVC.title = "채팅방 리스트"
          self?.navigationController?.pushViewController(chatListVC, animated: true)
        } else {
          // 실패면 network error
          print("실패함")
        }
        
       })

    }
  }
  
  @objc private func didTapRightBtn() {
    let newVC = NewConversationViewController()
    newVC.completion = { [weak self] result in
      self?.creatNewConversation(result: result)
      //      print("VC result: \(result)")
    }
    
    let naviVC = UINavigationController(rootViewController: newVC)
    naviVC.modalPresentationStyle = .overFullScreen
    present(naviVC, animated: true, completion: nil)
    
  }
  
  private func creatNewConversation(result: SearchResult) {
    let name = result.name
    let email = result.email
    
    let chatVC = ChatViewController(with: email, id: nil)
    chatVC.isNewConversation = true
    chatVC.title = name       // 대화하는 이름
    chatVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(chatVC, animated: true)
    
  }
  
  
}


extension ConversationsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conversations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = conversations[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
    cell.configure(with: model)
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // begin delete
      let conversationId = conversations[indexPath.row].id
      tableView.beginUpdates()
      
      DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { [weak self] success in
        if success {
          self?.conversations.remove(at: indexPath.row)
          
          tableView.deleteRows(at: [indexPath], with: .left)
        }
        
      })
      
      
      
      tableView.endUpdates()
    }
  }
  
  
}

extension ConversationsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let model = conversations[indexPath.row]
    openConversation(model)
    
  }
  
  func openConversation(_ model: Conversation) {
    let chatVC = ChatViewController(with: model.otherUserEmail, id: model.id)
    chatVC.title = model.name
    chatVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(chatVC, animated: true)
  }
  
  
  
}
