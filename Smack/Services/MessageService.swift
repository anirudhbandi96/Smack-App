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
    var selectedChannel : Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler){
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
//            print(URL_GET_CHANNELS)
//            print(AuthService.instance.authToken)
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                do{
                if let json = try JSON(data: data).array {
                    for item in json{
                        let title = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["id"].stringValue
                        
                        self.channels.append(Channel(channelTitle: title, channelDescription: description, id: id))
                        
                        
                        }
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        completion(true)
                    }
                }
                catch {
                    debugPrint(error)
                }
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func clearChannels(){
        channels.removeAll()
    }
    
}
