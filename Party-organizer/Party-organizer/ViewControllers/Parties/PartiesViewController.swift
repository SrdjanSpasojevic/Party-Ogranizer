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
    
    var noDataView: NoDataView!
    
    private struct CellIdentifer
    {
        static let partyCell = "partyCell"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
    override func setupUI()
    {
        super.setupUI()
        
        self.noDataView = NoDataView()
        self.noDataView.setTitle(title: "You have no party.\nCreate some")
        self.noDataView.setActionButtonTitle(title: "Create party")
        
        self.tableView.backgroundView = self.noDataView
    }
    
    override func loadData()
    {
        super.loadData()
        
        
    }

    @IBAction func addPartyAction(_ sender: UIBarButtonItem)
    {
        
    }
}

extension PartiesViewController: NoDataViewDelegate
{
    func actionButtonClicked(_ sender: UIButton)
    {
        //TODO: Create party action
    }
}

extension PartiesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifer.partyCell, for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}
