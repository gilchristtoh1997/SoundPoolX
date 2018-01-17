//
//  friendsViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 12/19/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit
import Firebase

class friendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedUserName: String?
    let friendsTableView = UITableView()
    let cellID = "cellID"
    var users = [User]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (friendsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if tableView == self.friendsTableView
        {
            let user = users[indexPath.row]
            
            cell.textLabel?.text = user.fullname
            cell.textLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUsersProfile)))
            cell.followButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
            cell.followButton.tag = indexPath.row

            if let profileImageSITE = user.profileImageURL {
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageSITE)
            }
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell  = friendsTableView.cellForRow(at: indexPath) as! UserCell
        selectedUserName = cell.textLabel?.text
        self.showUsersProfile()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.register(UserCell.self, forCellReuseIdentifier: cellID)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func comInit(bgColor : UIColor) {
        self.view.backgroundColor = bgColor
    }
    func CreateFriendsTableView() {
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(friendsTableView)
        
    }
    func fetchUsers()
    {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.fullname = dictionary["fullname"] as? String
                user.email = dictionary["email"] as? String
                if user.email != Auth.auth().currentUser?.email {
                    if !self.users.contains(user)
                    {
                        self.users.append(user)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.friendsTableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func followUser(_ sender: AnyObject) {
        var superview = sender.superview
        
        while let view = superview, !(view is UserCell) {
            superview = view?.superview
        }
        guard let cell = superview as? UserCell else {
            print("button is not contained in tvc")
            return
        }
        guard let indexPath = friendsTableView.indexPath(for: cell) else {
            print("failed to it")
            return
        }        
        let user = friendsTableView.cellForRow(at: indexPath)
        print("Following " ,(user?.textLabel?.text!)!)
    }
    func showUsersProfile() {
        let selectedProfile = currSelectedViewController()
        selectedProfile.view.backgroundColor = UIColor.white
        selectedProfile.edgesForExtendedLayout = []
        selectedProfile.navigationController?.navigationBar.isTranslucent = false
        self.show(selectedProfile, sender: (Any).self)
        selectedProfile.navigationItem.title = selectedUserName
        selectedProfile.navigationItem.rightBarButtonItem = selectedProfile.createOptionButton()
        selectedProfile.backGroundImageView.frame = CGRect(x: 0, y: 0, width: Int((selectedProfile.navigationController?.navigationBar.frame.width)!), height: 150)
        selectedProfile.frontImageView.frame = CGRect(x: 10, y: Int(((selectedProfile.navigationController?.navigationBar.frame.height)!)), width: 50, height: 50)
        selectedProfile.view.addSubview(selectedProfile.backGroundImageView)
        selectedProfile.view.addSubview(selectedProfile.frontImageView)
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "google")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let followButton: UIButton = {
        let fButton = UIButton()
        fButton.frame = CGRect(x: UserCell.accessibilityFrame().origin.x + 300, y: 20, width: 70, height: 30)
        fButton.setTitle("Follow", for: .normal)
        fButton.setTitleColor(UIColor.blue, for: .normal)
        fButton.layer.borderWidth = 1
        fButton.layer.borderColor = UIColor.black.cgColor
        return fButton
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(followButton)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 80).isActive = true
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
