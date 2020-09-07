//
//  Trans.swift
//  WebRTCTutorial
//
//  Created by viva iOS on 2020/08/25.
//  Copyright © 2020 Eric. All rights reserved.
//

import Alamofire

class Trans {
  let key = "AIzaSyAyLAw0rhcXql5iDGtTGKHSIrQyK3Hc0QM"
  let url = "https://translation.googleapis.com/language/translate/v2"
  
  func translate(target: String, completion: @escaping (String) -> ()) {
    
    let param: [String: Any] = [
      "key": key,
      "target": "en",
      "format": "text",
      "q": target
    ]
    
    AF.request(url, method: .post, parameters: param)
      .responseData {
        guard let data = $0.data else {
          completion("")
          return }
        guard let translated = try? JSONDecoder().decode(TranslatorModel.self, from: data) else {
          completion("")
          return }
        guard let trans = translated.data.translations.first else {
          completion("")
          return }
        completion(trans.translatedText)
    }
  }
}


// MARK: - TranslatorModel
struct TranslatorModel: Codable {
    let data: TransData
}

// MARK: - DataClass
struct TransData: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}
