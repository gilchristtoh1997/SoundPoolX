//
//  SignUpViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 6/8/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var info = [String: Any]()
class SignUpViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let chooseProfilePicViewController = profilePicViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createAccountAction(_ sender: Any) {
        if emailAddress.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            info = storeInfo()
            chooseProfilePicViewController.view.backgroundColor = UIColor.white
            chooseProfilePicViewController.view.addSubview(chooseProfilePicViewController.createProfilePic())
            chooseProfilePicViewController.view.addSubview(chooseProfilePicViewController.creatContinueButton())
            self.present(chooseProfilePicViewController, animated: true, completion: nil)
            
        }
    }

    func storeInfo() -> [String: Any]{
        var array = [String: Any]()
        array = ["fullname": FullName.text as Any, "username": username.text as Any, "email": emailAddress.text as Any, "password" : password.text as Any]
        return array
    }
    
    
    
}
