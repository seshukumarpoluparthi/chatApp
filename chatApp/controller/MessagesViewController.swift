//
//  MessagesViewController.swift
//  chatApp
//
//  Created by venkatarao on 29/05/18.
//  Copyright © 2018 Exaact. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "edit")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        // user is not logged in
        
            handleLogout()
        checkIfUserIsLoggedIn()
    }
    
   @objc func handleNewMessage()  {
    
    let newMessageController = NewMessageController()
    let navController = UINavigationController(rootViewController: newMessageController)
    present(navController, animated: true, completion: nil)
    
    
    }
        
        func checkIfUserIsLoggedIn(){
            if Auth.auth().currentUser?.uid == nil {
                perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
            } else {
                
                let uid = Auth.auth().currentUser?.uid
                
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

                   // print(snapshot)
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                       let user = User()
                        user.nam = dictionary["name"] as? String
                        self.navigationItem.title = user.nam
                    }
                }, withCancel: nil)
                
            }
    }
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let logincontroller = LoginController()
        present(logincontroller, animated: true , completion: nil)
    }
}

