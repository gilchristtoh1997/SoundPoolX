//
//  SignOutViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 6/9/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit
import Firebase


class SignOutViewController: UIViewController{
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LogoutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }

    @IBAction func DisplayFriends(_ sender: Any) {
        let friendsViewcontroller = friendsViewController()
        friendsViewcontroller.comInit(bgColor: UIColor.white)
        self.show(friendsViewcontroller, sender: sender)
        friendsViewcontroller.navigationItem.title = "Friends"
        friendsViewcontroller.CreateFriendsTableView()
        friendsViewcontroller.fetchUsers()
    }
    @IBAction func DisplayNotificationSettings(_ sender: Any) {
        let NotificationSettingsViewcontroller = UIViewController()
        NotificationSettingsViewcontroller.view.backgroundColor = UIColor.white
        self.show(NotificationSettingsViewcontroller, sender: sender)
        NotificationSettingsViewcontroller.navigationItem.title = "Settings"
    }
    
}


