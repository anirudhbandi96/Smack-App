//
//  MessageCell.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/18/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(msg: Message){
        message.text = msg.message
        userName.text = msg.userName
        profileImg.image = UIImage(named: msg.userAvatar)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: msg.userAvatarColor)
        
    }

}
