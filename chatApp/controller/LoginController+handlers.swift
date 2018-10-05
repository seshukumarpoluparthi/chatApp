//
//  LoginController+handlers.swift
//  chatApp
//
//  Created by venkatarao on 29/05/18.
//  Copyright © 2018 Exaact. All rights reserved.
//

import UIKit
import Firebase
    extension LoginController:UIImagePickerControllerDelegate,
        UINavigationControllerDelegate
    {
        @objc func handleSelectProfileImageview()
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            var selectedImagefromPicker : UIImage?
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
                //print(editedImage.size)
                selectedImagefromPicker = editedImage
            }
            else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            {
                //print(originalImage.size)
                selectedImagefromPicker = originalImage
            }
            if let selectedImage = selectedImagefromPicker {
                profileImageview.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
            //  print(info)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // print("cancelled picker")
            dismiss(animated: true, completion: nil)
        }
    }
