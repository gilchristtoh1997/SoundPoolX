//
//  currSelectedViewController.swift
//  SoundPool X
//
//  Created by Gilchrist Toh on 12/26/17.
//  Copyright © 2017 Gilchrist Toh. All rights reserved.
//

import UIKit

class optionSetting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
class currSelectedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellID = "cell"
    let cellHeight : CGFloat = 50
    let settings: [optionSetting] = {
        return [optionSetting(name: "Add to Playlist", imageName: "domain"),optionSetting(name: "Cancel", imageName: "ic_public_16")]
    }()
    
    let blackView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(optionCell.self, forCellWithReuseIdentifier: cellID)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let backGroundImageView: UIImageView = {
        let backImage = UIImageView()
        backImage.backgroundColor = UIColor.black
        backImage.image = UIImage(named: "The Goodnight - I Will Wait")
        return backImage
    }()
    
    func createOptionButton() -> UIBarButtonItem {
        let rightBarButton = UIBarButtonItem(title: "option", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleOptions(_:)))
        return rightBarButton
    }
    let frontImageView: UIImageView = {
        let frontImage = UIImageView()
        frontImage.backgroundColor = UIColor.black
        frontImage.image = UIImage(named: "google")
        frontImage.layer.borderWidth = 2
        frontImage.layer.borderColor = UIColor.blue.cgColor
        frontImage.layer.cornerRadius = 24
        frontImage.layer.masksToBounds = true
        frontImage.contentMode = .scaleAspectFill
        return frontImage
    }()
    func handleOptions(_ sender: UIBarButtonItem!) {
        if let screenWindow = UIApplication.shared.keyWindow
        {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
            
            screenWindow.addSubview(blackView)
            screenWindow.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y_value = screenWindow.frame.height - height
            collectionView.frame = CGRect(x: 0, y: screenWindow.frame.height, width: screenWindow.frame.width, height: height)
            
            
            blackView.frame = screenWindow.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y_value, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y_value, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            })
        }
    }
    func dismissView()
    {
        UIView.animate(withDuration: 0.5){
            self.blackView.alpha = 0
            if let keyWindow =  UIApplication.shared.keyWindow
            {
                self.collectionView.frame = CGRect(x: 0, y: keyWindow.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! optionCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addSongViewController = launchOptions()
        let setting = settings[indexPath.item]
        if setting.name == "Add to Playlist"
        {
            dismissView()
            addSongViewController.view.backgroundColor = UIColor.white
            addSongViewController.edgesForExtendedLayout = []
            addSongViewController.navigationController?.navigationBar.isTranslucent = true
            addSongViewController.view.addSubview(addSongViewController.createSearchBar())
            self.show(addSongViewController, sender: (Any).self)            
        }
        else {
            print(setting.name)
            dismissView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
