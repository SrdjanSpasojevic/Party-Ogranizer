//
//  PartyTableViewCell.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class PartyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with party: Party)
    {
        self.titleLabel.text = party.name
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM.dd.yyyy hh:mm"
        self.dateLabel.text = dateFormater.string(from: party.date)
        
        self.descriptionLabel.text = party.partyDescription
    }

}
