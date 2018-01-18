//
//  ChatVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/12/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ChatVC: UIViewController  , UITableViewDataSource , UITableViewDelegate{
    
    //variables
    
    var isTyping = false
   
    
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var ChannelNameLbl: UILabel!
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        sendButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        SocketService.instance.getChatMessage { (success) in
            if success {
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0{
                    let indIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indIndex, at: .bottom, animated: false)
                }
            }
        }
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers{
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    }else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true{
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            }else {
                self.typingUsersLbl.text = ""
            }
            
            
        
            
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            
            cell.configureCell(msg: MessageService.instance.messages[indexPath.row])
            return cell
        }
        return MessageCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextBox.text else { return }
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                    SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name , channelId)
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
        self.getMessages()
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        if messageTextBox.text == ""{
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name , channelId)
        }else{
            if isTyping == false {
                sendButton.isHidden = false
                SocketService.instance.manager.defaultSocket.emit("startType", UserDataService.instance.name, channelId)
                }
            isTyping = true
        }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        
        if AuthService.instance.isLoggedIn {
            // get channels
            onLoginGetMessages()
            
        }else {
            ChannelNameLbl.text = "Please log In"
            tableView.reloadData()
        }
        
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success {
                //do stuff with channels
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.ChannelNameLbl.text = "No Channels yet!"
                }
            }
        }
    }

    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

}
