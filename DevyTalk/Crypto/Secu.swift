//
//  Secu.swift
//  DevyTalk
//
//  Created by viva iOS on 2020/09/11.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation

class Secu {
  enum ErrorSecurity: Error {
    case failToMakeClearMessage, failToParsing, failToMakeServerKey, failToMakeAESClearKeyEncrypted, failToMakeRSAKey, failToEncryptPlainTextWithRandomIV, failToGetPK, failToMakeEncryptedMessage, failToMakeAESClearKeyDecrypted, failToMakeOriginAESKey, failToDecryptCipherTextRandomIV
  }
  
  private init() {}
  static let rity = Secu()
  private let cl = CryptLib()
  
  func encryptionMsg(_ clear: String, AESKey: String) -> String? {
    guard let encryptedText = self.cl.encryptPlainTextRandomIV(withPlainText: clear, key: AESKey) else {
      return nil }
    return encryptedText
  }
  
  func decryptionMsg(_ text: String, AESKey: String) -> String? {
    guard let clear = self.cl.decryptCipherTextRandomIV(withCipherText: text, key: AESKey) else {
      return nil }
    return clear
  }
  
  func getAESKey(chatID: String, generate: Bool, completion: @escaping (String?) -> ()) {
    if generate {
      let originAESKey = self.randomText(20)
      API.shared.saveAESKey(with: chatID, key: originAESKey)
      completion(originAESKey)
    } else {
      API.shared.getAESKey(with: chatID, completion: completion)
    }
  }
  
  
}


extension Secu {
  func randomText(_ length: Int) -> String {
    var chars = [UInt8]()
    
    while chars.count < length {
      let char = CharType.random().randomCharacter()
      if char == 32 && (chars.last ?? 0) == char {
        // do not allow two consecutive spaces
        continue
      }
      chars.append(char)
    }
    return String(bytes: chars, encoding: .ascii) ?? ""
  }
  
  /// Used for random text generation
  enum CharType: Int {
    case LowerCase, UpperCase, Digit
    
    func randomCharacter() -> UInt8 {
      switch self {
      case .LowerCase:
        return UInt8(Random().generate(26)) + 97
      case .UpperCase:
        return UInt8(Random().generate(26)) + 65
      case .Digit:
        return UInt8(Random().generate(10)) + 48
      }
    }
    
    static func random() -> CharType {
      return CharType(rawValue: Int(Random().generate(3)))!
    }
  }
  struct Random {
    func generate(_ upperBound: Int) -> Int {
      return Int(arc4random_uniform(UInt32(upperBound)))
    }
  }
}
