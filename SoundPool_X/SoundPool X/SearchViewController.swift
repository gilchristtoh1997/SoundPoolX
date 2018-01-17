//
//  SearchViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 6/9/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//
import UIKit
import Firebase
import AVKit
import AVFoundation
import FirebaseAuth

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    var refHandle : UInt!
    let popupView = UIView()
    let searchBar = UISearchBar()
    let navBar = UIView()
    var filteredSongs = [String]()
    let songsTableView = UITableView()
    let cell = "cellID"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(createNavBar())
        self.edgesForExtendedLayout = []
        self.CreateSongsTableView()
        self.view.addSubview(createSearchBar())
        searchBar.delegate = self
        songsTableView.delegate = self
        songsTableView.dataSource = self
        songsTableView.tableHeaderView = searchBar
        songsTableView.register(SearchCell.self, forCellReuseIdentifier: cell)
        definesPresentationContext = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchText: searchBar.text!)
        songsTableView.reloadData()
    }
    func CreateSongsTableView() {
        songsTableView.frame = CGRect(x: 0, y: searchBar.frame.origin.y + searchBar.frame.size.height, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(songsTableView)
    }
    func createNavBar() -> UIView{
        let navBar = UIView()
        navBar.backgroundColor = UIColor.white
        navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        let controllerTitle = UILabel()
        controllerTitle.frame = CGRect(x: 8, y: 50, width: navBar.frame.width, height: 30)
        controllerTitle.text = "Search"
        controllerTitle.font = UIFont(name: "Times New Roman", size: 35)
        navBar.addSubview(controllerTitle)
        return navBar
    }
    func createSearchBar() -> UISearchBar{
        searchBar.frame = CGRect(x: 0, y: navBar.frame.origin.y + navBar.frame.size.height, width: self.view.frame.width, height: 70)
        searchBar.placeholder = "Click to Search"
        return searchBar
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongs.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (songsTableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as? SearchCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.font = UIFont(name: "Avenir", size: 12)
        cell.textLabel?.text = list[indexPath.row]
        cell.optionsButton.addTarget(self, action: #selector(addSongsToPlaylist), for: .touchUpInside)
        return cell
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        filterContentForSearchText(searchText: searchBar.text!)
        self.songsTableView.reloadData()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
        songsTableView.reloadData()
    }
    func filterContentForSearchText(searchText: String)
    {
        self.filteredSongs = list.filter({ (word) -> Bool in
            let stringMatch = word.lowercased().range(of: searchText.lowercased())
            return stringMatch != nil ? true : false
            
        })
        
    }
    
    func addSongsToPlaylist() {
        if let screenWindow = UIApplication.shared.keyWindow
        {
            let tLabel = UILabel()
            popupView.backgroundColor = UIColor.black
            screenWindow.addSubview(popupView)
            screenWindow.addSubview(tLabel)
            let height: CGFloat = CGFloat(60)
            let y_value = (self.tabBarController?.tabBar.frame.origin.y)! - height
            popupView.frame = CGRect(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)!, width: screenWindow.frame.width, height: 0)
            popupView.alpha = 0
            tLabel.frame = CGRect(x: 16, y: (self.tabBarController?.tabBar.frame.origin.y)! - 40, width: popupView.frame.width, height: 25)
            tLabel.textColor = UIColor.white
            tLabel.text = "Song Added"
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.popupView.alpha = 1
                self.popupView.frame = CGRect(x: 0, y: y_value, width: screenWindow.frame.width, height: height)
                
            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.popupView.alpha = 1
                self.popupView.frame = CGRect(x: 0, y: y_value, width: screenWindow.frame.width, height: height)
            })
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                UIView.animate(withDuration: 0.5){
                    self.popupView.alpha = 0
                    if let keyWindow =  UIApplication.shared.keyWindow
                    {
                        tLabel.removeFromSuperview()
                        self.popupView.frame = CGRect(x: 0, y: (self.tabBarController?.tabBar.frame.origin.y)!, width: keyWindow.frame.width, height: 0)
                    }
                }
            })
            
        }
        
    }
    
    
    
    
   
    /**func update_number_of_plays()
    {
        refHandle = Database.database().reference().child("Songs").observe(.value, with: { (snapshot) in
            print(snapshot)
            var array: [String:Int] = [:]
            for item in snapshot.children.allObjects as! [DataSnapshot]
            {
                if item.key == "Miley Cyrus - Party In The USA"
                {
                    array["Miley Cyrus - Party In The U.S.A."] = item.value as? Int
                    continue
                }
                array[item.key] = item.value as? Int
                
            }
            self.playsArray = array
            DispatchQueue.main.async(execute: {
                
                self.myTable.reloadData()
            })
            print(self.playsArray)
        })
    }**/
    
}

class SearchCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 52 , y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
    }
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "google")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let optionsButton: UIButton = {
        let adButton = UIButton()
        adButton.frame = CGRect(x: SongCell.accessibilityFrame().origin.x + 350, y: 10, width: 20, height: 20)
        adButton.setTitle("+", for: .normal)
        adButton.setTitleColor(UIColor.blue, for: .normal)
        adButton.layer.borderWidth = 1
        adButton.layer.borderColor = UIColor.black.cgColor
        return adButton
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(cellImageView)
        addSubview(optionsButton)
        cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        cellImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        optionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
