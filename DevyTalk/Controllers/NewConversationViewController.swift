//
//  NewConversationViewController.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import SnapKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
  
  let newConversationsView = NewConversationsView()
 
  public var completion: ((SearchResult) -> (Void))?
  // search
  private var users = [[String: String]]()
  
  private var results = [SearchResult]()
  
  private var hasFetched = false
  
  private let spinner = JGProgressHUD(style: .dark)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appColor(.whiteTwo)
    
    setupNavi()
    addSubViews()
    setupSNP()
    
    newConversationsView.tableView.dataSource = self
    newConversationsView.tableView.delegate = self
    
    newConversationsView.searchBar.delegate = self
    

    
  }
  
  private func setupNavi() {
    title = "NewChat"
    navigationController?.navigationBar.topItem?.titleView = newConversationsView.searchBar
    
    let rightBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
    rightBtn.tintColor = .appColor(.gr1)
    
    navigationItem.rightBarButtonItem = rightBtn
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 35.i) ?? UIFont()]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15.i) ?? UIFont()]
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .appColor(.whiteTwo)
    
  }
  
  @objc private func dismissSelf() {
    dismiss(animated: true, completion: nil)
  }
  
  private func addSubViews() {
    [newConversationsView]
      .forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    newConversationsView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
}

extension NewConversationViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: " ").isEmpty else {
      return
    }
    
    searchBar.resignFirstResponder()
    results.removeAll()
    spinner.show(in: view)
    
    self.searchUsers(query: text)
  }
  
  func searchUsers(query: String) {
    // check if array has firebase results
    if hasFetched {
      // if it dose: filter
      filterUsers(with: query)
    } else {
      // if not, fetch then filter
      DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
        switch result {
        case .success(let usersCollection):
          self?.hasFetched = true
          self?.users = usersCollection
          
          self?.filterUsers(with: query)
        case .failure(_):
          ()
        }
      })
      
    }
    
    
  }
  
  func filterUsers(with term: String) {
    // update the UI: show results or show no results label
    guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
      
      return
    }
    
    let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
    
    self.spinner.dismiss()
    
    let results: [SearchResult] = self.users.filter({
      guard let email = $0["email"], email != safeEmail, let name = $0["name"]?.lowercased() else {
          return false
      }
      
      return name.hasPrefix(term.lowercased())
      
      }).compactMap({
        guard let email = $0["email"], let name = $0["name"] else {
            return nil
        }
        
        return SearchResult(name: name, email: email)
      })
    
    self.results = results
    
    updateUI()
    
  }
  
  // updateUI
  func updateUI() {
    if results.isEmpty {
      newConversationsView.noResultsLabel.isHidden = false
      newConversationsView.tableView.isHidden = true
    } else {
      newConversationsView.noResultsLabel.isHidden = true
      newConversationsView.tableView.isHidden = false
      newConversationsView.tableView.reloadData()
    }
  }
  
}
// UITableVeiw DataSource, Delegate
extension NewConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = results[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationCell.identifier, for: indexPath) as! NewConversationCell
    cell.configure(with: model)
    cell.selectionStyle = .none
    return cell
  }
  

}

extension NewConversationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // start conversation
    let targetUserData = results[indexPath.row]
    
    dismiss(animated: true, completion: { [weak self] in
      self?.completion?(targetUserData)
    })
    
    
  }

}
