//
//  NoDataView.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/3/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit

protocol NoDataViewDelegate {
    func actionButtonClicked(_ sender: UIButton)
}

class NoDataView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var delegate: NoDataViewDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
        addSubview(self.contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.actionButton.roundCorners(cornerRadius: 10.0)
    }

    @IBAction func buttonAction(_ sender: UIButton)
    {
        self.delegate?.actionButtonClicked(sender)
    }
    
    func setTitle(title: String)
    {
        self.titlelabel.text = title
    }
    
    func setActionButtonTitle(title: String)
    {
        self.actionButton.setTitle(title, for: .normal)
    }
}
