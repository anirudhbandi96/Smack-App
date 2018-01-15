//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/13/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    
    
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passtext: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    //Variables
    var avatarName = "smackProfileIcon"
    var avatarColor = "[0.5,0.5,0.5,1]"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pickBgColorPressed(_ sender: Any) {
        
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
        
    }
    @IBAction func createAccntPressed(_ sender: Any) {
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passtext.text, passtext.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success{
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name,UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
