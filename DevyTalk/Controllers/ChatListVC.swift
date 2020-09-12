//
//  ChatListVC.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/01.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class ChatListVC: UIViewController {
  
  var uid: String = ""
  
  var hosData: (String, String) = ("", "")      //(chatUser.hosID ?? "hosID", chatUser.hosNAME ?? "hosName")
  
  let userMe: UserMe = UserMe.shared
  
  var chatUser: UserData?
  
  let checkListView = ChatListView()
  
  var chatList = [ChatList]() {
    didSet {
      checkListView.tableView.reloadData()
    }
  }
  
  let backIV: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "bookNowBackIV")
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  let seeView: UIView = {
    let view = UIView()
    view.backgroundColor = .appColor(.aPp)
    view.layer.cornerRadius = 23.i
    view.isUserInteractionEnabled = true
    return view
  }()
  
  let infoLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumSquareB", size: 15.i)
    label.text = "대기실 신규 입장"
    label.textColor = .appColor(.whiteTwo)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.isHidden = true
    view.backgroundColor = .white
    setupNavi()
    addSubViews()
    setupSNP()
    
    checkListView.tableView.dataSource = self
    checkListView.tableView.delegate = self
    
    
    seeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSeeView)))
    
    
    // childAdded
    DatabaseManager.shared.checkChatList(uid) { [weak self] result in
      switch result {
        case .success(let value):
          var tempList = self?.chatList
          tempList?.append(value)
          self?.chatList = tempList?.sorted(by: { (lef, ref) -> Bool in
            let lTime = TimeInterval(lef.lastMessage?.mMessageDate?.time ?? 0)
            let rTime = TimeInterval(ref.lastMessage?.mMessageDate?.time ?? 0)
            let lDate = Date(timeIntervalSince1970: lTime)
            let rDate = Date(timeIntervalSince1970: rTime)
            return lDate > rDate
          }) ?? []
        //        self?.chatList.insert(value, at: 0)
        // 채팅방에 갯수는 몇갠지 몰르는데 총 갯수를 가져온다
        case .failure(_):
          ()
      }
    }
    
    //  childChanged
    DatabaseManager.shared.checkLastMessage(uid) { [weak self] result in
      guard let `self` = self else { return }
      switch result {
        case .success(let value):
          var index: Int = -1
          for (idx, inside) in self.chatList.enumerated() {
            if inside.chatID == value.chatID {
              index = idx
              break
            }
          }
          
          guard index != -1 else { return }   // -1인 이유는 nil을 대신한 것
          //        self.chatList[index] = value
          self.chatList.remove(at: index)
          self.chatList.insert(value, at: 0)
        
        case .failure(let err):
          
          dump(err)
      }
    }
    
    
  }
  
  @objc private func didTapSeeView() {
    // chatList가 없을때 신규방
    DatabaseManager.shared.findChat(hosKey: self.hosData.0) {
      switch $0 {
        case .success(let user):    // user -> 원무과유저데이터 or 간호사유저데이터
          
          guard let otherKey = user["doc_ID"] as? String,
            let name = user["doc_NAME"] as? String else {
              return
          }
          DatabaseManager.shared.createChatRoom(otherKey: otherKey, myKey: self.userMe.user.docID ?? "docID", hosKey: self.hosData.0, name: name, completion: { (id, aes) in
            DispatchQueue.main.async {
              let newChatVC = NewChatVC()
              newChatVC.aesKey = aes
              newChatVC.title = self.hosData.1
              newChatVC.chatID = id
              newChatVC.hosData = self.hosData
              self.navigationController?.pushViewController(newChatVC, animated: false)
            }
          }) { (message) in
            
        }
        
        case .failure(_):
          ()
      }
    }
  }
  
  private func addSubViews() {
    [backIV, checkListView, seeView]
      .forEach { view.addSubview($0) }
    seeView.addSubview(infoLabel)
    
  }
  
  private func setupSNP() {
    backIV.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(329.i)
    }
    
    checkListView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
    seeView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40.i)
      $0.trailing.equalToSuperview().offset(-20.i)
      $0.height.equalTo(47.i)
    }
    
    infoLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(15.i)
      $0.leading.trailing.equalToSuperview().inset(18.i)
    }
  }
  
  
  private func setupNavi() {
    // naviSet
    let leftBtn = UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(leftBtnDidTap(_:)))
    leftBtn.tintColor = .appColor(.aBk)
    
    navigationItem.leftBarButtonItem = leftBtn
    
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    
    
  }
  @objc func leftBtnDidTap(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
    //    navigationController?.popViewController(animated: true)
  }
  
  
}

extension ChatListVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case 0:
        return 2
      case 2:
        return 1
      default:
        return chatList.count == 0 ? 1 : chatList.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
      case 0:
        switch indexPath.row {
          case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: WaitingInfoCell.identifier, for: indexPath) as! WaitingInfoCell
            cell.selectionStyle = .none
            return cell
          default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCell.identifier, for: indexPath) as! AppointmentCell
            cell.selectionStyle = .none
            return cell
      }
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoWaitingCell.identifier, for: indexPath) as! InfoWaitingCell
        cell.selectionStyle = .none
        return cell
      default:
        if chatList.count == 0 {
          // 아무것도 안했을때 기본 방은 여기 - 안내멘트있고
          let cell = tableView.dequeueReusableCell(withIdentifier: BasicWaitingCell.identifier, for: indexPath) as! BasicWaitingCell
          cell.selectionStyle = .none
          return cell
        } else {
          
          // 채팅한 방이 있으면 여기로
          let cell = tableView.dequeueReusableCell(withIdentifier: GlobalWaitingCell.identifier, for: indexPath) as! GlobalWaitingCell
          cell.chat = chatList[indexPath.row]
          cell.selectionStyle = .none
          return cell
      }
      
    }
  }
  
  
}

extension ChatListVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section != 0, indexPath.section != 2 else { return }
    
    if chatList.count == 0 {
      // chatList가 없을때 신규방
      DatabaseManager.shared.findChat(hosKey: self.hosData.0) {
        switch $0 {
          case .success(let user):    // user -> 원무과유저데이터 or 간호사유저데이터
            
            guard let otherKey = user["doc_ID"] as? String,
              let name = user["doc_NAME"] as? String else {
                return
            }
            DatabaseManager.shared.createChatRoom(otherKey: otherKey, myKey: self.userMe.user.docID ?? "docID", hosKey: self.hosData.0, name: name, completion: { (id, aes) in
              DispatchQueue.main.async {
                let newChatVC = NewChatVC()
                newChatVC.aesKey = aes
                newChatVC.title = self.hosData.1
                newChatVC.chatID = id
                newChatVC.hosData = self.hosData
                self.navigationController?.pushViewController(newChatVC, animated: false)
              }
            }) { (message) in
              
          }
          
          case .failure(_):
            ()
        }
      }
      
      //      DatabaseManager.shared.findChat(hosKey: self.hosData.0) {
      //        switch $0 {
      //        case .success(let user):    // user -> 원무과유저데이터 or 간호사유저데이터
      //          print("user", user)
      //          guard let otherKey = user["doc_ID"] as? String,
      //            let name = user["doc_NAME"] as? String else {
      //              return
      //          }
      //          DatabaseManager.shared.createChatRoom(otherKey: otherKey, myKey: self.userMe.user.docID ?? "docID", hosKey: self.hosData.0, name: name, completion: { (result) in
      //            print("result: ", result )
      //          }) { (message) in
      //            print("message: ", message)
      //          }
      //          let newChatVC = NewChatVC()
      //          newChatVC.title = self.hosData.1
      //          newChatVC.hosData = self.hosData
      //          newChatVC.navigationController?.navigationItem.title = nil
      //            let backBarBtn = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
      //          self.navigationItem.backBarButtonItem = backBarBtn
      //          self.navigationItem.backBarButtonItem?.tintColor = .white
      //          newChatVC.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
      //          self.navigationController?.pushViewController(newChatVC, animated: false)
      //        case .failure(let err):
      //          print(err.localizedDescription)
      //        }
      //      }
      
    } else {
      // 기존에 채팅한 기록이 있을때 기존방
      let chat = chatList[indexPath.row]
      guard let chatID = chat.chatID else {
        print("noChatID")
        return }
      Secu.rity.getAESKey(chatID: chatID, generate: false) {
        guard let aes = $0 else { return }
        DispatchQueue.main.async {
          let newChatVC = NewChatVC()
          newChatVC.aesKey = aes
          newChatVC.title = self.hosData.1
          newChatVC.chatID = chat.chatID ?? ""
          newChatVC.hosData = self.hosData
          self.navigationController?.pushViewController(newChatVC, animated: false)
        }
      }
      
      
    }
    
    
  }
}
