//
//  BaseViewController.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/3/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    //To be inherited
    
    /**
     SetupUI - Setup UI and set default values, init objects... \n Called on super.viewDidLoad()
     */
    func setupUI()
    {
        
    }
    
    /**
     loadData - Load data from the server \n Called on super.viewWillAppear(animated: Bool)
     */
    func loadData()
    {
        
    }
    

}
