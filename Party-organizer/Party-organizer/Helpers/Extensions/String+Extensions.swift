//
//  String+Extensions.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation

extension String
{
    func removeCharacters(characters: String) -> String
    {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: "")
        return result
    }
}
