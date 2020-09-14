//
//  LanguageSettingVC.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class LanguageSettingVC: UIViewController {
  
  let languageSettingView = LanguageSettingView()
  
  var tempLanguage: [(String, Bool)] = [("Republick of Korea", false), ("English(US)", false), ("Mongolia", false)]
  
  weak var newChatVC: NewChatVC?
  
  var feedData: [LanguageModel] = [] {
    didSet {
      languageSettingView.tableView.reloadData()
    }
  }
  
  var languageArr: [String] = [] {
    didSet {
      self.languageSettingView.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
    
    setupNavi()
    addSubViews()
    setupSNP()
    
    languageSettingView.tableView.dataSource = self
    languageSettingView.tableView.delegate = self
    
    languageSettingView.completeBtn.addTarget(self, action: #selector(didTapCompleteBtn(_:)), for: .touchUpInside)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
  }
  
  @objc private func didTapCheckViewBtn(_ sender: UIButton) {
    
    
  }
  
  @objc private func didTapCompleteBtn(_ sender: UIButton) {
    //    guard let vc = self.doctorCardListVC else {
    //      return }
    //    if doctorCardListVC?.mediSubArr != mediSubArr {
    //      doctorCardListVC?.mediSubArr = mediSubArr
    //      doctorCardListVC?.mainSubKey = mainSubkey
    //      doctorCardListVC?.downloadBase()  // 새로운 값으로 치환
    //    }
    
    navigationController?.popViewController(animated: true)
    
  }
  
  private func addSubViews() {
    [languageSettingView]
      .forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    languageSettingView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  @objc func didTapButton(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
    //    navigationController?.popToRootViewController(animated: true)
  }
  
  private func setupNavi() {
    // naviSet
    let leftBtn = UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(didTapButton(_:)))
    leftBtn.tintColor = .appColor(.aBk)
    navigationItem.leftBarButtonItem = leftBtn
    
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .white
  }
  
  
}

extension LanguageSettingVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tempLanguage.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LanguageSettingCell.identifier, for: indexPath) as! LanguageSettingCell
    cell.feedData = tempLanguage[indexPath.row].0
    cell.checkBtn.isSelected = tempLanguage[indexPath.row].1
    
    if indexPath.row == tempLanguage.count {
      cell.checkBtn.alpha = 0
      cell.checkBtn.isEnabled = false
    } else {
      cell.checkBtn.alpha = 1
      cell.checkBtn.isEnabled = true
    }
    cell.selectionStyle = .none
    return cell
  }
  
}

extension LanguageSettingVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row != tempLanguage.count else { return }
    
    tempLanguage.indices.forEach {
      tempLanguage[$0].1 = false
    }
    tempLanguage[indexPath.row].1 = true
    languageSettingView.tableView.reloadData()
    languageSettingView.completeBtn.tag = indexPath.row
    languageSettingView.completeBtn.backgroundColor = .appColor(.aPk)
  }
  
  
  
}
