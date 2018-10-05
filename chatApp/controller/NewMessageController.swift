//
//  NewMessageController.swift
//  chatApp
//
//  Created by venkatarao on 29/05/18.
//  Copyright © 2018 Exaact. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellid = "cellid"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        fetchUser()
        
        
    }
    
    func fetchUser()  {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String:AnyObject]{
               // print(dictionary)
                
             let user = User()
              // user.setValuesForKeys(dictionary)
             //  user.setValue(dictionary, forKey: "name")
            user.nam = dictionary["name"] as? String
            user.emal = dictionary["email"] as? String
               // print(user.nam!)
               // print(user.emal!)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                
            }
            
            
            
            
            
           
       // print(snapshot)
            
            
        }, withCancel: nil)
        
        
        
        
    }
    
    
    
    @objc func handleCancel(){
        
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let user = users[indexPath.row]
        
        
      //  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        cell.textLabel?.text = user.nam
        cell.detailTextLabel?.text = user.emal
        
       return cell
        
        
    }
    

}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
