//
//  PartiesViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/3/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class PartiesViewController: BaseViewController
{    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [Party] = []
    var notificationToken: NotificationToken?
    
    var noDataView: NoDataView!
    
    private struct CellIdentifer
    {
        static let partyCell = "partyCell"
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
        
        self.noDataView = NoDataView()
        self.noDataView.setTitle(title: "You have no party.\nCreate some")
        self.noDataView.setActionButtonTitle(title: "Create party")
        self.noDataView.delegate = self
        
        self.tableView.backgroundView = self.noDataView
    }
    
    override func loadData()
    {
        super.loadData()
        
        
        self.getParties()
    }

    @IBAction func addPartyAction(_ sender: UIBarButtonItem)
    {
        
    }
    
    private func getParties()
    {
        let realm = RealmEngine.shared.realm
        
        self.dataSource.removeAll()
        
        for profileObject in realm.objects(Party.self)
        {
            self.dataSource.append(profileObject)
        }
        
        
        self.notificationToken = realm.observe({ [weak self] (notification, realm) in
            self?.tableView.reloadData()
        })
        
        RealmEngine.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No erros")
        }
        
        self.tableView.reloadData()
        
        self.noDataView.isHidden = self.dataSource.count > 0 ? true : false
    }
    
    deinit {
        print("deinit called on PartiesVC")
        self.notificationToken?.invalidate()
        RealmEngine.shared.stopObservingErrors(in: self)
    }
}

extension PartiesViewController: NoDataViewDelegate
{
    func actionButtonClicked(_ sender: UIButton)
    {
        //TODO: Create party action
        self.performSegue(withIdentifier: "partiesToCreateParty", sender: nil)
    }
}

extension PartiesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifer.partyCell, for: indexPath) as? PartyTableViewCell else
        {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        
        let party = self.dataSource[indexPath.row]
        
        cell.configure(with: party)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
}

extension PartiesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        guard editingStyle == .delete else
        {
            return
        }
        
        let party = self.dataSource[indexPath.row]
        RealmEngine.shared.delete(party)
        self.dataSource.remove(at: indexPath.row)
        self.getParties()

    }
}
