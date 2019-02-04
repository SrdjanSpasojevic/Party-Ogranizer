//
//  ProfileTableViewCell.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with profile: Profile)
    {
        self.nameLabel?.text = profile.username
        
        self.profileImageView?.roundCorners(cornerRadius: (self.profileImageView?.frame.size.height)!/2)
        self.profileImageView?.sd_setShowActivityIndicatorView(true)
        self.profileImageView?.sd_setIndicatorStyle(.gray)
        
        let imageURL = URL(string: profile.photoURL)
        self.profileImageView?.sd_setImage(with: imageURL, completed: { (image, error, cache, url) in
            self.profileImageView.alpha = 0.0
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.profileImageView.alpha = 1.0
            }, completion: nil)
        })
        
        self.accessoryType = .disclosureIndicator
    }

}
