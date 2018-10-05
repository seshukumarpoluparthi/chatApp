//
//  ViewController.swift
//  chatApp
//
//  Created by venkatarao on 28/05/18.
//  Copyright © 2018 Exaact. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
            //handleLogout()
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

