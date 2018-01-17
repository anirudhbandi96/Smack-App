//
//  ProfileVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/15/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func setupView(){
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(closeTap)
    }

}
