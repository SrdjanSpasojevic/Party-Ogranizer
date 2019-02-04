//
//  Party.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


@objcMembers class Party: Object
{
    dynamic var id: String!
    dynamic var name: String!
    dynamic var partyDescription: String? = nil
    dynamic var date: Date!
    var members = List<String>()
    
    convenience init(name: String, partyDescription: String? = "", date: Date, members: List<String>?)
    {
        self.init()
        
        self.id = UUID().uuidString
        self.name = name
        self.partyDescription = partyDescription
        self.date = date
        self.members = members ?? List()
    }
    
    func toDict() -> [String : Any]
    {
        var toReturn: [String : Any] = [:]
        
        toReturn["id"] = self.id
        toReturn["name"] = self.name
        toReturn["partyDescription"] = self.partyDescription
        toReturn["date"] = self.date
        toReturn["members"] = self.members
        
        return toReturn
    }
}
