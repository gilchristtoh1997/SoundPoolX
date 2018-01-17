//
//  profilePicViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 12/20/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit
import Firebase

class profilePicViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let profilePic = UIImageView()
    var continueButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleSelectProfilePic() {
        let img_Picker = UIImagePickerController()
        img_Picker.delegate = self
        img_Picker.allowsEditing = true
        present(img_Picker, animated: true, completion: nil)
    }
    func createProfilePic() -> UIImageView {
        profilePic.frame = CGRect(x: 90, y: self.view.frame.height - 250, width: 70, height: 100)
        profilePic.backgroundColor = UIColor.black
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilePic)))
        profilePic.isUserInteractionEnabled = true
        return profilePic
    }
    func creatContinueButton() -> UIButton{
        continueButton = UIButton(frame: CGRect(x: 90, y: self.view.frame.height - 100, width: 70, height: 30))
        continueButton.setTitle("continue", for: .normal)
        continueButton.backgroundColor = UIColor.black
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.addTarget(self, action: #selector(showLoginPage(sender:)), for: .touchUpInside)
        return continueButton
    }
    func printSomethin() {
        print(info)
    }
    func showLoginPage(sender: UIButton!) {
        Auth.auth().createUser(withEmail: info["email"] as! String, password: info["password"] as! String) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(imageName)
            if let uploadData = UIImagePNGRepresentation(self.profilePic.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["fullname": info["fullname"]!, "username": info["username"]!, "email": info["email"]!,"profileImageURL": profileImageURL]
                        self.registerUserIntoDBWITHUserID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
            if error == nil {
                print("You have successfully signed up")
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Login") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    func registerUserIntoDBWITHUserID(uid: String, values: [String: AnyObject]) {
        reference = Database.database().reference(fromURL: "https://soundpool-x.firebaseio.com/")
        let usersRef = reference?.child("users").child((uid))
        usersRef?.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if err != nil
            {
                print(err!)
                return
            }
            else
            {
                print("picture uploaded")
            }
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePic.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
