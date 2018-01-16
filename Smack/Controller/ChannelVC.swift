//
//  ChannelVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/12/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    
    //Outlets

    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthService.instance.isLoggedIn {
            setupUserInfo()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell{
            cell.configureCell(channel: MessageService.instance.channels[indexPath.row])
            
            return cell
        }
        return ChannelCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        
       setupUserInfo()
        
    }
    
    func setupUserInfo(){
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }
    
    
    @IBAction func addChanel(_ sender: Any) {
        
        let add = AddChannelVC()
        add.modalPresentationStyle = .custom
        present(add, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            //Show Profile Page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else{
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    
}
