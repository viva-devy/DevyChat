//
//  TabBarViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
  let conversationsInstance = ConversationsViewController()
  let profileInstance = ProfileViewController() 
  
  let mainItem = UITabBarItem(title: "Chat", image: nil, selectedImage: nil)
  let secondItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //      conversationsInstance.tabbar = self
    let conversationsVC = UINavigationController(rootViewController: conversationsInstance)
    conversationsVC.tabBarItem.title = ""
    if #available(iOS 13.0, *) {
      conversationsVC.tabBarItem.image = UIImage(systemName: "message")
    } else {
      // Fallback on earlier versions
    }
    conversationsVC.navigationBar.isHidden = false
    
    let newConversationsVC = UINavigationController(rootViewController: profileInstance)
    newConversationsVC.tabBarItem.title = ""
    if #available(iOS 13.0, *) {
      conversationsVC.tabBarItem.image = UIImage(systemName: "person.circle")
    } else {
      // Fallback on earlier versions
    }
    newConversationsVC.navigationBar.isHidden = false
    
    conversationsVC.tabBarItem = mainItem
    newConversationsVC.tabBarItem = secondItem
    
    viewControllers = [conversationsVC, newConversationsVC]
    
    let appearance = UITabBar.appearance()
    appearance.barTintColor = .white
    
    
  }
  
}
