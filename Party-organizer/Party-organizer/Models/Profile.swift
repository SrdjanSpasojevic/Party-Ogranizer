//
//  Profile.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/2/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

@objcMembers class Profile: Object
{
    var id: String!
    var username: String!
    var cellPhone: String!
    var photoURL: String!
    var email: String!
    var gender: String!
    var aboutMe: String!
    
    convenience init(dict: JSON)
    {
        self.init()
        self.id = dict["id"].intValue.stringValue
        self.username = dict["username"].stringValue
        self.cellPhone = dict["cell"].stringValue
        self.photoURL = dict["photo"].stringValue
        self.gender = dict["gender"].stringValue
        self.aboutMe = dict["aboutMe"].stringValue
    }
}
