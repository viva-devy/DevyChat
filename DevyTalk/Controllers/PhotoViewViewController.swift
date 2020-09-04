//
//  PhotoViewViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoViewViewController: UIViewController {
  
  private let url: URL
  
  let photoView = PhotoView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appColor(.aBk)
    view.addSubview(photoView)
    photoView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    photoView.imageView.sd_setImage(with: self.url, completed: nil)
  }
  
  init(with url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
