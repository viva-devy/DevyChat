//
//  StorageManager.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/26.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
  
  static let shared = StorageManager()
  
  private let storage = Storage.storage().reference()
  
  /*
   /images/heaji-gamil-com_prifile_picture.png
   */
  
  
  public typealias UploadPictureCompletion = (Result <String, Error>) -> Void
  
  // Uploads picture to firebase storage and returns options url string to download
  public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
    storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
      guard let strongSelf = self else {
        return
      }
      
      guard error == nil else {
        // failed
        
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        
        let urlString = url.absoluteString
        
        completion(.success(urlString))
      })
    })
  }
  
  // Uploads image that will be sent in a conversation message
  public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
    storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
      guard let strongSelf = self else {
        return
      }
      
      guard error == nil else {
        
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      strongSelf.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        
        let urlString = url.absoluteString
        
        completion(.success(urlString))
      })
    })
  }
  
  /// Upload video that will be sent in a conversation message
  public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
    storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
      guard error == nil else {
        // failed
        
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        
        let urlString = url.absoluteString
        
        completion(.success(urlString))
        
      })
    })
  }
  
  
  public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadUrl
  }
  
  public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
    let reference = storage.child(path)
    reference.downloadURL { (url, err) in
      guard let url = url, err == nil else {
        completion(.failure(StorageErrors.failedToGetDownloadUrl))
        return
      }
      
      completion(.success(url))
    }
  }
  
}





