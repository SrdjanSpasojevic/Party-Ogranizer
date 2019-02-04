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

class MembersViewController: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataSource: [Profile] = []
    var notificationToken: NotificationToken?
    
    private struct CellIdentifier
    {
        static let profileCell = "profileCell"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func setupUI()
    {
        super.setupUI()
    }
    
    override func loadData()
    {
        super.loadData()
        
        let realm = RealmEngine.shared.realm
        
        for profile in realm.objects(Profile.self)
        {
            self.dataSource.append(profile)
        }
        
        self.notificationToken = realm.observe({ (notification, realm) in
            self.tableView.reloadData()
        })
        
        RealmEngine.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No erros")
        }
        
        if self.dataSource.count == 0
        {
            self.getProfiles()
        }
    }
    
    private func getProfiles()
    {
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        ServerCommunication.shared.getProfiles { (profiles, error) in
            
            self.activityIndicator.stopAnimating()
            
            if error == nil,
                let profiles = profiles
            {
                self.dataSource = profiles
                self.tableView.reloadData()
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

}

extension MembersViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.profileCell, for: indexPath)
        
        let profile = self.dataSource[indexPath.row]
        
        cell.textLabel?.text = profile.username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

extension MembersViewController: UITableViewDelegate
{
    
}
