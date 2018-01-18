//
//  MessageService.swift
//  Smack
//
//  Created by Anirudh Bandi on 1/15/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel : Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler){
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                do{
                if let json = try JSON(data: data).array {
                    for item in json{
                        let title = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        self.channels.append(Channel(channelTitle: title, channelDescription: description, id: id))
                        
                        
                        }
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        completion(true)
                    }
                }
                catch {
                    debugPrint(error)
                    completion(false)
                }
            }
            else{
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGES)/\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
                self.clearMessages()
                guard let data = response.data else { return }
                do {
                if let json = try JSON(data: data).array {
                    for item in json{
                        let messageBody = item["messageBody"].stringValue
                        let userName = item["userName"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let id = item["_id"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        self.messages.append(Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp))
                        print(self.messages)
                       
                    }
                }
                 completion(true)
                }catch {
                    debugPrint(error)
                    completion(false)
                }
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearMessages(){
        messages.removeAll()
    }
    
    func clearChannels(){
        channels.removeAll()
    }
    
}
