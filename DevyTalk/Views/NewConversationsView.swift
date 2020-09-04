//
//  NewConversationsView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class NewConversationsView: UIView {
  
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.becomeFirstResponder()
    searchBar.placeholder = "Search for Users..."
    return searchBar
  }()
  
  lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.backgroundColor = .white
    tb.separatorStyle = .none
    tb.isScrollEnabled = true
    tb.isHidden = true
    tb.showsVerticalScrollIndicator = false
    tb.register(NewConversationCell.self, forCellReuseIdentifier: NewConversationCell.identifier)
    tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.i, right: 0)
    return tb
  }()
  
  let noResultsLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.text = "No Results"
    label.font = UIFont(name: "NanumSquareEB", size: 15.i)
    label.textColor = .appColor(.gr2)
    label.textAlignment = .center
    return label
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
    
    
  }
  
  private func addSubViews() {
    [searchBar, tableView, noResultsLabel]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {

    tableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    noResultsLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(50.i)
      $0.leading.equalToSuperview().offset(25.i)
    }
  }
  
}


