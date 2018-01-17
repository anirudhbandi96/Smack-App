//
//  ChatVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/12/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var ChannelNameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        
       
    }
    
    @objc func channelSelected(_ notif: Notification){
        
    updateWithChannel()
    }
    
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        ChannelNameLbl.text = "#\(channelName)"
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        
        if AuthService.instance.isLoggedIn {
            // get channels
            onLoginGetMessages()
            
        }else {
            ChannelNameLbl.text = "Please log In"
        }
        
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success {
                //do stuff with channels
            }
        }
    }

   

}
