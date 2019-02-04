//
//  String+Extensions.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import RealmSwift

extension String
{
    func removeCharacters(characters: String) -> String
    {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: "")
        return result
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
}

extension List
{
    func remove(at index:Int, completion: @escaping ((Bool, Error?) -> ()))
    {
        do
        {
            try RealmEngine.shared.realm.write {
                self.remove(at: index)
                
                completion(true, nil)
            }
        }
        catch
        {
            completion(false, error)
        }
    }
    
    func append(_ object: Element, completion: @escaping ((Bool, Error?) -> ()) )
    {
        do
        {
            try RealmEngine.shared.realm.write {
                self.append(object)
                
                completion(true, nil)
            }
        }
        catch
        {
            completion(false, error)
        }
    }
}
