//
//  CreatePartyViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/4/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import PureLayout
import RealmSwift

class CreatePartyViewController: BaseViewController
{
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePickerHolder: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backgroundViewBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerHolderBottom: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var partyNameLabel: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var party: Party!
    var members: List<Int>!
    
    var dataSource: [String] = []
    
    var selectedDate: Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    override func setupUI()
    {
        super.setupUI()
        
        self.datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .editingDidBegin)
        self.hideDatePicker(animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveParty))
    }
    
    override func loadData()
    {
        super.loadData()
        
        self.dataSource.append("Members (\(self.dataSource.count))")
    }
    
    @IBAction func openDatePickerAction(_ sender: UITapGestureRecognizer)
    {
        //TODO: Open DatePicker
        self.showDatePicker(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton)
    {
        self.hideDatePicker(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIButton)
    {
        self.hideDatePicker(animated: true)
    }
    
    //MARK: Private methods
    private func showDatePicker(animated: Bool)
    {
        self.datePickerHolder.isHidden = false
        self.backgroundView.isHidden = false
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0.6
            }
            
            UIView.animate(withDuration: 1.4, delay: 0.3, options: .curveEaseIn, animations: {
                self.datePickerHolderBottom.constant = 0.0
            }, completion: nil)
        }
        else
        {
            self.backgroundView.alpha = 0.6
            
            self.datePickerHolderBottom.constant = 0.0
        }
        
    }
    
    private func hideDatePicker(animated: Bool)
    {
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 1.4, delay: 0.3, options: .curveEaseOut, animations: {
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
    
    @objc private func dateChanged(_ sender: UIDatePicker)
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "mm.dd.yyyy hh:mm"
        self.startDateLabel.text = dateFormater.string(from: sender.date)
        
        self.selectedDate = sender.date
    
    }
    
    @objc private func saveParty()
    {
        self.members = List()
        let party = Party(name: self.partyNameLabel.text ?? "", partyDescription: self.descriptionTextView.text, date: self.selectedDate, members: self.members)
        
        RealmEngine.shared.add(party)
    }
}

extension CreatePartyViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        
        let memberData = self.dataSource[indexPath.row]
        
        if indexPath.row == 0
        {
            cell.accessoryType = .disclosureIndicator
        }
        else
        {
            cell.backgroundColor = .lightGray
        }
        
        cell.textLabel?.text = memberData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
}

extension CreatePartyViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        guard editingStyle == .delete else
        {
            return
        }
        
        if indexPath.row != 0
        {
            self.members.remove(at: indexPath.row)
        }
    }
}
