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
        print("failed to upload data to firebase for picture")
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          print("Failed to get download url")
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        
        let urlString = url.absoluteString
        print("download url returned: \(urlString)")
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
        print("failed to upload data to firebase for picture")
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      strongSelf.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          print("Failed to get download url")
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        print("들어오나여")
        let urlString = url.absoluteString
        print("download url returned: \(urlString)")
        completion(.success(urlString))
      })
    })
  }
  
  /// Upload video that will be sent in a conversation message
  public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
    storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
      guard error == nil else {
        // failed
        print("failed to upload video file to firebase for picture")
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
        guard let url = url else {
          print("Failed to get download url")
          completion(.failure(StorageErrors.failedToGetDownloadUrl))
          return
        }
        
        let urlString = url.absoluteString
        print("download url returned: \(urlString)")
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





