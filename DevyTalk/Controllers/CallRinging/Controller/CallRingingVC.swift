//
//  CallRingingVC.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/09/14.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit

class CallRingingVC: UIViewController {
  
  let callRingingView = CallRingingView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = true
    
    addSubViews()
    setupSNP()
    
    
  }
  
  private func addSubViews() {
    [callRingingView]
      .forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    callRingingView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
}
