//
//  MembersViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/3/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import QuartzCore
import SDWebImage

enum DisplayType
{
    case selectMemebers
    case previewMembers
}

class MembersViewController: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataSource: [Profile] = []
    var notificationToken: NotificationToken?
    
    private var currentDisplayType: DisplayType = .previewMembers
    
    var members: List<Int> = List()
    
    var selectedProfileIndex = 0
    
    private struct CellIdentifier
    {
        static let profileCell = "profileCell"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupUI()
    {
        super.setupUI()
        
        self.activityIndicator.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.savePartyMembers))
        
        if self.currentDisplayType == .previewMembers
        {
            self.tabBarController?.tabBar.isHidden = false
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func loadData()
    {
        super.loadData()
        
        
        let realm = RealmEngine.shared.realm
        
        if dataSource.count == 0
        {
            for profileObject in realm.objects(Profile.self)
            {
                self.dataSource.append(profileObject)
            }
        }
        
        self.notificationToken = realm.observe({ [weak self] (notification, realm) in
            self?.tableView.reloadData()
        })
        
        RealmEngine.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No erros")
        }
        
        if self.dataSource.count == 0
        {
            self.getProfiles()
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "membersToProfile",
            let profileVC = segue.destination as? ProfileViewController
        {
            weak var _self = self
            profileVC.profile = _self?.dataSource[(_self?.selectedProfileIndex)!]
        }
    }
    
    //MARK: Public methods
    func setDisplayType(to type: DisplayType)
    {
        self.currentDisplayType = type
    }
    
    //MARK: Private methods
    @objc private func savePartyMembers()
    {
        if let createPartyVC = self.navigationController?.viewControllers[1] as? CreatePartyViewController
        {
            createPartyVC.members = self.members
            createPartyVC.newMembersAdded()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getProfiles()
    {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        ServerCommunication.shared.getProfiles { [weak self] (profiles, error) in
            
            self?.activityIndicator.stopAnimating()
            
            if error == nil,
                let profiles = profiles
            {
                self?.dataSource = profiles
                self?.tableView.reloadData()
                RealmEngine.shared.add(profiles)
               
                
                //TODO: UPDATE
                //                let profile = JSON(profiles[0]).dictionaryObject!
                //                RealmEngine.shared.update(profiles[0], with: profile)
            }
            else
            {
                AlertHelper.presentAlert(on: self, message: "Error loading profiles\nPlease try again")
            }
        }
    }
    
    deinit {
        print("deinit called in MembersVC")
        self.notificationToken?.invalidate()
        RealmEngine.shared.stopObservingErrors(in: self)
    }

}

extension MembersViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.profileCell, for: indexPath) as? ProfileTableViewCell else
        {
            return UITableViewCell()
        }
        
        let profile = self.dataSource[indexPath.row]
        cell.configureCell(with: profile)
        
        if self.currentDisplayType == .previewMembers
        {
            cell.accessoryType = .disclosureIndicator
        }
        else if self.currentDisplayType == .selectMemebers
        {
            if self.members.contains(self.dataSource[indexPath.row].id.intValue)
            {
                cell.accessoryType = .checkmark
            }
            else
            {
                
                cell.accessoryType = .none
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        if self.currentDisplayType == .previewMembers
        {
            self.selectedProfileIndex = indexPath.row
            self.notificationToken?.invalidate()
            RealmEngine.shared.stopObservingErrors(in: self)
            
            self.performSegue(withIdentifier: "membersToProfile", sender: nil)
        }
        else if self.currentDisplayType == .selectMemebers
        {
            if self.members.contains(self.dataSource[indexPath.row].id.intValue),
                let index = self.members.index(of: self.dataSource[indexPath.row].id.intValue)
            {
                self.members.remove(at: index)
                cell?.accessoryType = .none
            }
            else
            {
                self.members.append(self.dataSource[indexPath.row].id.intValue)
                cell?.accessoryType = .checkmark
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
}

extension MembersViewController: UITableViewDelegate
{
    
}
