//
//  PhotoView.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/28.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit

class PhotoView: UIView {

  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.layer.masksToBounds = true
    return iv
  }()
   
   override func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.backgroundColor = .clear
     addSubViews()
     setupSNP()
    
   }
   
   private func addSubViews() {
     [imageView].forEach {
       self.addSubview($0)
     }
   }
   
   
   private func setupSNP() {
     imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
     }
   }
   

}
