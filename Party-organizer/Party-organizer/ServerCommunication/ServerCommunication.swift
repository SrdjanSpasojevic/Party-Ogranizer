//
//  ServerCommunication.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/2/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerCommunication: NSObject
{
    static let shared = ServerCommunication()
    
    private struct ServerURLs
    {
        static let BASE_URL = URL(string: "http://api-coin.quantox.tech/profiles.json")!
    }
    
    func getProfiles(completion: @escaping (_ profiles: [Profile]?,_ error: Error?)->())
    {
        Alamofire.request(ServerURLs.BASE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/json"]).responseJSON { (response) in
            
            if let responseData = response.result.value
            {
                let json = JSON(responseData)
                let profilesRaw = json["profiles"].arrayValue
                var profiles: [Profile] = []
                var counter = 0
                
                for profileRaw in profilesRaw
                {
                    let profile = Profile(dict: profileRaw)
                    profiles.append(profile)
                    counter += 1
                }
                
                if counter == profilesRaw.count
                {
                    completion(profiles, nil)
                }
            }
            else
            {
                completion(nil, response.result.error)
            }
        }
    }
}
