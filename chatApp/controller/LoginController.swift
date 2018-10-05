//
//  LoginController.swift
//  chatApp
//
//  Created by venkatarao on 28/05/18.
//  Copyright © 2018 Exaact. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    var inputscontainerviewheightAnchor : NSLayoutConstraint?
    var nametextfieldHeightAnchor : NSLayoutConstraint?
    var emailtextfieldHeightAnchor : NSLayoutConstraint?
    var passwordtextfieldHeightAnchor : NSLayoutConstraint?
    
    lazy var profileImageview : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mahesh")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageview)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //   @objc func handleSelectProfileImageview(){
    //        print(123)
    //
    //    }
    let loginRegisterSegmentedcontrol : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    @objc func handleLoginRegisterChange(){
        // print(loginRegisterSegmentedcontrol.selectedSegmentIndex)
        //  print(loginRegisterSegmentedcontrol.titleForSegment(at: loginRegisterSegmentedcontrol.selectedSegmentIndex) as Any)
        let title = loginRegisterSegmentedcontrol.titleForSegment(at: loginRegisterSegmentedcontrol.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //change height of inputcontainerview
        inputscontainerviewheightAnchor?.constant = loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 100 : 150
        //change height of nametextfield
        nametextfieldHeightAnchor?.isActive = false
        nametextfieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 0 : 1/3)
        nametextfieldHeightAnchor?.isActive = true
        emailtextfieldHeightAnchor?.isActive = false
        emailtextfieldHeightAnchor = emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailtextfieldHeightAnchor?.isActive = true
        passwordtextfieldHeightAnchor?.isActive = false
        passwordtextfieldHeightAnchor = passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordtextfieldHeightAnchor?.isActive = true
    }
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    @objc func handleLoginRegister()  {
        if loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    func handleLogin(){
        guard let email = emailTextfield.text,let password = passwordTextfield.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            //succesfully logged in our user
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func handleRegister()  {
        guard let emailt = emailTextfield.text,let password = passwordTextfield.text,let namet = nameTextfield.text else {
            print("form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: emailt, password: password)
        {(user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.user.uid else {return}
            // let data = Data()
            let storageRef = Storage.storage().reference().child("myImage.png")
            if  let uploadData = UIImagePNGRepresentation(self.profileImageview.image!)
            {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    guard let metadata = metadata else {return}
                    let size = metadata.size
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {return}
                    })
                    if error != nil {
                        print(error)
                        return
                    }
                    //print(metadata)
                })
            }
            let ref = Database.database().reference(fromURL: "https://chatapp-68355.firebaseio.com/")
            //check it .child(uid)
            let usersReference = ref.child("users").child(uid)
            let values = ["name":namet,"email":emailt]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                print("saved user succesfully into firebase db")
            })
        }
        print("seshu : successfully authenticated user")
    }
    let nameTextfield : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextfield : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextfield : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let passwordSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageview)
        view.addSubview(loginRegisterSegmentedcontrol)
        setupInputsContainerview()
        setupLoginRegisterButton()
        setupProfileImageview()
        setuploginRegisterSegmentedcontrol()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setupProfileImageview()  {
        // need x,y,width,height constraints
        NSLayoutConstraint.activate([
            profileImageview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageview.bottomAnchor.constraint(equalTo: loginRegisterSegmentedcontrol.topAnchor, constant: -12),
            profileImageview.widthAnchor.constraint(equalToConstant: 150),
            profileImageview.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    func setuploginRegisterSegmentedcontrol()  {
        NSLayoutConstraint.activate([
            loginRegisterSegmentedcontrol.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedcontrol.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12),
            loginRegisterSegmentedcontrol.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor , multiplier : 1),
            loginRegisterSegmentedcontrol.heightAnchor.constraint(equalToConstant: 36)
            ])
    }
    

    func setupInputsContainerview(){
        // need x,y,width,height constraints
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            // inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            ])
        inputscontainerviewheightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputscontainerviewheightAnchor?.isActive = true
        inputsContainerView.addSubview(nameTextfield)
        // need x,y,width,height constraints
        NSLayoutConstraint.activate([
            nameTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            nameTextfield.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            nameTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            // nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            ])
        nametextfieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nametextfieldHeightAnchor?.isActive = true
        inputsContainerView.addSubview(nameSeparatorView)
        NSLayoutConstraint.activate([
            nameSeparatorView.leftAnchor.constraint(equalTo: nameTextfield.leftAnchor),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
            ])
        inputsContainerView.addSubview(emailTextfield)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextfield)
        inputsContainerView.addSubview(passwordSeparatorView)
        NSLayoutConstraint.activate([
            emailTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor),
            emailTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            // emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            ])
        emailtextfieldHeightAnchor = emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailtextfieldHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            emailSeparatorView.leftAnchor.constraint(equalTo: nameTextfield.leftAnchor),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor),
            emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            passwordTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor),
            passwordTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            //  passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            ])
        passwordtextfieldHeightAnchor = passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordtextfieldHeightAnchor?.isActive = true
    }
    func setupLoginRegisterButton() {
        // need x,y,width,height constraints
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}

extension UIColor {
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat ){
        self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
