//
//  Party.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class Party: Object
{
    dynamic var id: String!
    dynamic var name: String!
    dynamic var partyDescription: String? = nil
    dynamic var date: Date!
    dynamic var members: List<Int>? = nil
    
    convenience init(name: String, partyDescription: String? = "", date: Date, members: List<Int>?)
    {
        self.init()
        
        self.id = UUID().uuidString
        self.name = name
        self.partyDescription = partyDescription
        self.date = date
        self.members = members
    }
}
