//
//  AddChannelVC.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/15/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

   
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createChannel(_ sender: Any) {
        
        guard let channelName = nameTxt.text, nameTxt.text != "" else { return }
        guard let channelDesc = descriptionTxt.text else { return }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success {
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    func setupView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeTapped(_:)))
        self.view.addGestureRecognizer(tap)
        
        nameTxt.attributedText = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        descriptionTxt.attributedText = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
    }
    
    @objc func closeTapped(_ rec: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
}
