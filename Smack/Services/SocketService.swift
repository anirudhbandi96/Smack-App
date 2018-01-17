//
//  SocketService.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/16/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    
    func establishConnection() {
        
        manager.defaultSocket.connect()
    
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        
        
        manager.defaultSocket.emit("newChannel", channelName,channelDescription)
        completion(true)
        
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
            
        }
        
    }
    
    

}
