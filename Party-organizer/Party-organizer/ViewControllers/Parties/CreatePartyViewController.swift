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
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePickerHolder: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backgroundViewBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerHolderBottom: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var partyNameLabel: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var party: Party!
    var members: List<String> = List()
    
    var dataSource: [String] = []
    
    var selectedDate: Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    override func setupUI()
    {
        super.setupUI()
        
        self.datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        self.hideDatePicker(animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveParty))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDatePicker))
        tapGesture.numberOfTapsRequired = 1
        self.startDateTextField.addGestureRecognizer(tapGesture)
        
        if self.party != nil
        {
            self.partyNameLabel.text = party.name
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MM.dd.yyyy hh:mm"
            self.startDateTextField.text = dateFormater.string(from: party.date)
            self.descriptionTextView.text = party.partyDescription
            
            self.members = self.party.members
            
            self.newMembersAdded()
        }
    }
    
    override func loadData()
    {
        super.loadData()
        
        if self.dataSource.count == 0
        {
             self.dataSource.append("Members (\(self.dataSource.count))")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "partyToMembers",
            let membersVC = segue.destination as? MembersViewController
        {
            membersVC.setDisplayType(to: .selectMemebers)
            membersVC.members = self.members
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton)
    {
        self.hideDatePicker(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIButton)
    {
        self.hideDatePicker(animated: true)
    }
    
    //MARK: Public methods
    func newMembersAdded(resetData: Bool = true)
    {
        let realm = RealmEngine.shared.realm
        var counter = 0
        
        if resetData
        {
            self.dataSource.removeAll()
            self.dataSource.append("Members (\(self.dataSource.count-1))")
        }
        
        for profileObject in realm.objects(Profile.self)
        {
            if self.members.contains(profileObject.id)
            {
                self.dataSource.append(profileObject.username)
                counter += 1
            }
        }
        
        //+1 because we have "Members (count)" object allways in array
        if counter + 1 == self.dataSource.count
        {
            self.dataSource[0] = "Members (\(self.dataSource.count-1))"
            self.tableView.reloadData()
        }
    }
    
    //MARK: Private methods
    @objc func openDatePicker()
    {
        self.resignFirstResponder()
        self.showDatePicker(animated: true)
    }
    
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
        dateFormater.dateFormat = "MM.dd.yyyy hh:mm"
        self.startDateTextField.text = dateFormater.string(from: sender.date)
        
        self.selectedDate = sender.date
    
    }
    
    @objc private func saveParty()
    {
        if self.party != nil
        {
            RealmEngine.shared.update(self.party, with: self.party.toDict())
        }
        else
        {
            let party = Party(name: self.partyNameLabel.text ?? "", partyDescription: self.descriptionTextView.text, date: self.selectedDate, members: self.members)
            
            RealmEngine.shared.add(party)
        }
        
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("Deinit called on CreatePartyVC")
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
        
        cell.accessoryType = .none
        cell.backgroundColor = .white
        
        if indexPath.row == 0
        {
            cell.accessoryType = .disclosureIndicator
        }
        else
        {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
        
        
         cell.textLabel?.text = self.dataSource[indexPath.row]
        
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
            self.members.remove(at: indexPath.row-1) { (done, error) in
                
                if done
                {
                    self.newMembersAdded()
                }
                
                print(error ?? "No errors")
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            self.performSegue(withIdentifier: "partyToMembers", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
