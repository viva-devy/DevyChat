//
//  API.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/11.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Alamofire

class API {
  static let shared = API()
  private init() {}
  
  let jsonHeader: HTTPHeaders = [
    "Content-Type": "application/json"
  ]
  
  func saveAESKey(with chatID: String, key: String) {
    let url = "https://adocviva.com/kinddoc/untact/chat/ec"
    
    let param: [String: Any] = [
      "code": 6600,
      "cid": chatID,
      "ek": key,
    ]
    
    guard let data = try? JSONSerialization.data(withJSONObject: param) else { return }
    
    AF.upload(data, to: url, method: .post, headers: jsonHeader)
    .resume()
    
  }
  
  func getAESKey(with chatID: String, completion: @escaping (String?) -> ()) {
    let url = "https://adocviva.com/kinddoc/untact/chat/ec"
    
    let param: [String: Any] = [
      "code": 6601,
      "cid": chatID
    ]
    
    guard let data = try? JSONSerialization.data(withJSONObject: param) else { return }
    
    AF.upload(data, to: url, method: .post, headers: jsonHeader).responseJSON {
      guard let value = $0.value as? [String: [String: String]],
        let result = value["result"],
        let key = result["ENCRYPT_KEY"] else {
        completion(nil)
        return }
      completion(key)
    }
    
    
    
    
  }
}
