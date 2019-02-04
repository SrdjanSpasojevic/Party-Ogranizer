//
//  ProfileViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController
{

    @IBOutlet weak var addToButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    weak var profile: Profile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
    }
    
    override func setupUI()
    {
        super.setupUI()
        
        self.addToButton.roundCorners(cornerRadius: 10.0)
        self.profileImageView.roundCorners(cornerRadius: self.profileImageView.frame.size.height/2)
        let imageURL = URL(string: profile.photoURL)
        self.profileImageView?.sd_setImage(with: imageURL, completed: { (image, error, cache, url) in
            self.profileImageView.alpha = 0.0

            UIView.transition(with: self.profileImageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.profileImageView.image = image
                self.profileImageView.alpha = 1.0
            }, completion: nil)
        })

        self.nameLabel.text = "Full name: \(self.profile.username ?? "")"
        self.genderLabel.text = "Gender: \(self.profile.gender ?? "")"
        self.emailLabel.text = "email: \(self.profile.email ?? "")"
        self.aboutLabel.text = "About:"
        self.aboutTextView.text = self.profile.aboutMe
        self.aboutTextView.isEditable = false
    }
    
    @IBAction func addToButtonAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func callButtonAction(_ sender: UIBarButtonItem)
    {
        guard let number = URL(string: "tel://" + self.profile.cellPhone) else
        {
            return
        }
        
        UIApplication.shared.open(number)
    }
    
    deinit {
        print("Deinit celled on profile")
    }
    
}
