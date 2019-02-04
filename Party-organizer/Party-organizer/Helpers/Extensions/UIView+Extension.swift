//
//  UIView+Extension.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/3/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit

extension UIView
{
    func roundCorners(cornerRadius: CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
