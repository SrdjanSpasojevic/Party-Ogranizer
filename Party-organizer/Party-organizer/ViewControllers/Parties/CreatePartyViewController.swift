//
//  CreatePartyViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import PureLayout

class CreatePartyViewController: BaseViewController
{
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePickerHolder: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backgroundViewBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerHolderBottom: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    override func setupUI()
    {
        super.setupUI()
        
        self.hide(animated: false)
    }
    
    @IBAction func openDatePickerAction(_ sender: UITapGestureRecognizer)
    {
        //TODO: Open DatePicker
        self.show(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton)
    {
        self.hide(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIButton)
    {
        self.hide(animated: true)
    }
    
    func show(animated: Bool)
    {
        self.datePickerHolder.isHidden = false
        self.backgroundView.isHidden = false
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0.6
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                self.datePickerHolderBottom.constant = 0.0
            }, completion: nil)
        }
        else
        {
            self.backgroundView.alpha = 0.6
            
            self.datePickerHolderBottom.constant = 0.0
        }
        
    }
    
    func hide(animated: Bool)
    {
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                self.datePickerHolderBottom.constant = (self.datePickerHolder.frame.size.height + 100.0)
            }, completion: nil)
        }
        else
        {
            self.backgroundView.alpha = 0.0
            
            self.datePickerHolderBottom.constant = (self.datePickerHolder.frame.size.height + 100.0)
        }
        
        self.datePickerHolder.isHidden = true
        self.backgroundView.isHidden = true
    }
}
